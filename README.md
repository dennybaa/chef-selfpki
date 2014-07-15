# Chef cookbook SelfPKI

The cookbook allows generating client certificates signed by CA in place. This means that the key and certificate of CA should be distributed with the cookbook.

## selfpki resource

### Actions

<table>
  <tr>
    <th>Action</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>:create</tt></td>
    <td>Generates client key pair</td>
  </tr>
  <tr>
    <td><tt>:delete</tt></td>
    <td>Removes client key pair</td>
  </tr>
</table>

### Attributes

<table>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>cookbook</tt></td>
    <td>Specifies cookbook where the Certificate Authority is stored.</td>
  </tr>
  <tr>
    <td><tt>cert_source</tt></td>
    <td>Specifies the certificate source path. Default value: <i>"ca.crt"</i>.</td>
  </tr>
  <tr>
    <td><tt>key_source</tt></td>
    <td>Specifies the private key source path. Default value: <i>"ca.key"</i>.</td>
  </tr>
  <tr>
    <td><tt>cert_path</tt></td>
    <td>Specifies the path where the new generated client certificate is stored.</td>
  </tr>
  <tr>
    <td><tt>key_path</tt></td>
    <td>Specifies the path where the new generated private key is stored.</td>
  </tr>
  <tr>
    <td><tt>key_mode</tt></td>
    <td>Specifies the file creation mode of the client key file. Default value: <i>00600</i>.</td>
  </tr>
  <tr>
    <td><tt>cert_owner</tt></td>
    <td>Specifies the client certificate file owner. Default value: <i>"root"</i>.</td>
  </tr>
  <tr>
    <td><tt>key_owner</tt></td>
    <td>Specifies the client private key file owner. Default value: <i>"root"</i>.</td>
  </tr>
  <tr>
    <td><tt>recreate</tt></td>
    <td>If set to <i>true</i> the client key pair is recreated. Default value: <i>false</i>.</td>
  </tr>
  <tr>
    <td><tt>config</tt></td>
    <td>Hash of certificate creation options such os OU, CN etc.</td>
  </tr>
  <tr>
    <td><tt>server_cert</tt></td>
    <td>If set to <i>true</i> the server certificate will be created. Default value: <i>false</i>.</td>
  </tr>
</table>

## Usage

### Typical resource invokation

<pre lang="ruby"><code>
selfpki 'consul' do
  key_path  '/tmp/consul-key.pem'
  cert_path '/tmp/consul-cert.pem'
  cookbook  'mycookbook'
end
</code></pre>


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Denis Baryshev (<dennybaa@gmail.com>)
