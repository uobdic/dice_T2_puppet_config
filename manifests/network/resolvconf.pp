#https://github.com/thias/puppet-resolvconf
class site::network::resolvconf (
  $header     = 'This file is managed by Puppet, do not edit',
  $nameserver = [],
  $domain     = '',
  $search     = [],
  $options    = []) inherits site::params {
  if $domain != '' and $search != [] {
    fail('The "domain" and "search" parameters are mutually exclusive.')
  }

  if $nameserver != [] {
    file { '/etc/resolv.conf':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/resolv.conf.erb"),
    }
  }
}
