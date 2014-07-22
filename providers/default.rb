def whyrun_supported?
  true
end

action :create do
  nokeypair = [@new_resource.cert_path, @new_resource.key_path].any? {|p| !::File.exist?(p)}
  if nokeypair || @new_resource.recreate
    tmpdir = "/tmp/chef-selfpki-#{@new_resource.name}"
    create_keypair

    file new_resource.key_path do
      mode    new_resource.key_mode
      owner   new_resource.key_owner
      owner   new_resource.key_group
      content lazy { ::IO.read("#{tmpdir}/#{node[:fqdn]}.key") }
    end
    file new_resource.cert_path do
      mode    00644
      owner   new_resource.key_owner
      owner   new_resource.key_group
      content lazy { ::IO.read("#{tmpdir}/#{node[:fqdn]}.crt") }
    end
    directory tmpdir do
      recursive true
      action :delete
    end
  end
end

action :delete do
  file new_resource.key_path do
    action :delete
  end
  file new_resource.cert_path do
    action :delete
  end
end

private

def create_keypair
  tmpdir = "/tmp/chef-selfpki-#{@new_resource.name}"
  # create CA snapshot
  directory tmpdir do
    owner 'root'
    group 'root'
    mode  00755
  end
  file "#{tmpdir}/index.txt" do
    owner 'root'
    group 'root'
    mode  00644
  end
  file "#{tmpdir}/serial" do
    content "01"
    owner 'root'
    group 'root'
    mode  00644
  end
  %w(openssl.cnf vars).each do |f|
    fcbk = "#{f}".gsub(/\./, '_') + '_cookbook'
    fcbk = node['selfpki'][fcbk] || 'selfpki'
    template "#{tmpdir}/#{f}" do
      variables(config: new_resource.config)
      source "#{f}.erb"
      owner 'root'
      group 'root'
      mode  00755
      cookbook(fcbk.to_s)
    end
  end
  cookbook_file "#{tmpdir}/ca.crt" do
    source(new_resource.cert_source || 'ca.crt')
    owner 'root'
    group 'root'
    mode  00644
    cookbook(new_resource.cookbook || new_resource.cookbook_name.to_s)
  end
  cookbook_file "#{tmpdir}/ca.key" do
    source(new_resource.key_source || 'ca.key')
    owner 'root'
    group 'root'
    mode  00644
    cookbook(new_resource.cookbook || new_resource.cookbook_name.to_s)
  end

  # generate key pair
  line_args = new_resource.server_cert ? '--server' : ''
  cmd_str = %Q%/bin/sh -c ". ./vars; /bin/sh #{pkitool_cached_path} #{line_args} #{node[:fqdn]}"%
  execute cmd_str do
    cwd  tmpdir
  end
end

def pkitool_cached_path
  cookbook = @run_context.cookbook_collection['selfpki']
  cookbook.preferred_filename_on_disk_location(node, :files, 'pkitool.sh')
end