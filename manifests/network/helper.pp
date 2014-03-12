define site::network::helper (
  $type            = 'dynamic',
  $interface       = {
  }
  ,
  $interface_slave = {
  }
  ,
  $route           = {
  }
  ,) {
  if $type == 'dynamic' {
    create_resources('network::if::dynamic', $interface)
  } elsif $type == 'static' {
    create_resources('network::if::static', $interface)
  } elsif $type == 'bridge' {
    create_resources('network::if::bridge', $interface)
  } elsif $type == 'alias' {
    create_resources('network::if::alias', $interface)
  } elsif $type == 'bond_dynamic' {
    create_resources('network::bond::dynamic', $interface)
    create_resources('network::bond::slave', $interface_slave)
  } elsif $type == 'bond_static' {
    create_resources('network::bond::static', $interface)
    create_resources('network::bond::slave', $interface_slave)
  } elsif $type == 'route' {
    create_resources('network::route', $route)
  }
}
