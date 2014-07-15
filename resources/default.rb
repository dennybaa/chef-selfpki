actions :create, :delete
default_action :create

attribute :cookbook,    :kind_of => String
attribute :cert_source, :kind_of => String
attribute :key_source,  :kind_of => String
attribute :cert_path,   :kind_of => String, :required => true
attribute :key_path,    :kind_of => String, :required => true
attribute :key_mode,    :kind_of => [String, Fixnum], :default => 00600
attribute :key_owner,   :kind_of => [String, Fixnum], :default => 'root'
attribute :key_group,   :kind_of => [String, Fixnum], :default => 'root'
attribute :recreate,    :kind_of => [TrueClass, FalseClass], :default => false
attribute :server_cert, :kind_of => [TrueClass, FalseClass], :default => false

def initialize(name, run_context=nil)
  super
  @pki_default = Mash.new({
    ca_expire: 3650,
    expire:    3650,
    size:      1024,
    country:   'GB',
    province:  '',
    city:      'London',
    org:       'OhaiChefs',
    ou:        '',
    email:     'me@example.com'
  })
end

def config(hash=nil)
  if hash
    unless hash.kind_of?(Hash)
      raise Exceptions::ValidationFailed, "Option ca_config must be kind_of Hash! You passed #{value.inspect}."
    end
    @pki_config = @pki_default.merge(hash)
  else
    @pki_config ||= @pki_default.dup
    puts '------------'
    puts @pki_config
    @pki_config
  end
end