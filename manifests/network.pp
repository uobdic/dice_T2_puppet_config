# A bit of a messy network config
class site::network (
  $configure_hosts   = false,
  $configure_network = false,
  $configure_routes  = false,
  $gateway           = undef,
  $hosts             = {
    'host1.example.com' => {
      ip           => '127.0.0.1',
      host_aliases => 'host1',
    }
    ,

  }
  ,
  $interfaces        = {
  }
  ,
  $nameserver        = [],
  $routes            = {
  }
  ,
  $search            = [],) {
  if $configure_hosts {
    create_resources('host', $hosts)
  }

  if $configure_network {
    class { 'network::global':
      hostname   => $::fqdn,
      gateway    => $gateway,
      nozeroconf => 'yes',
    }

    # this is going into the network config
    if $::domain != '' and $search != [] {
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

    class { 'site::network::resolvconf':
      nameserver => $nameserver,
      search     => $search,
    }
  }

  if $configure_routes {
    # this should be /etc/rc.d/rc.local on SL6
    # and should be only applied to machines with no public ip!
    # this can be also done via razorsedge/network
    file { '/etc/rc.d/rc.local':
      ensure  => present,
      content => template('${module_name}/rc.local.erb'),
    }
  }

}
