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