class site::reverse_proxy (
  $service_ports = {
  }
) {
  firewall { '100 snat for network DICE':
    chain    => 'POSTROUTING',
    jump     => 'MASQUERADE',
    proto    => 'all',
    outiface => 'em2',
    source   => '10.132.0.0/16',
    table    => 'nat',
  }

  firewall { '101 snat for network DICE':
    chain    => 'POSTROUTING',
    jump     => 'SNAT',
    proto    => 'all',
    outiface => 'em2',
    tosource => $::ipaddress_em2,
    table    => 'nat',
  }

  firewall { '102 forwarding from internal network':
    chain    => 'FORWARD',
    action   => 'accept',
    proto    => 'all',
    outiface => 'em2',
    source   => '10.132.0.0/16',
  }

  firewall { '103 forwarding to internal network':
    chain       => 'FORWARD',
    action      => 'accept',
    proto       => 'all',
    iniface     => 'em2',
    state       => [
      'ESTABLISHED',
      'RELATED'],
    destination => '10.132.0.0/16',
  }

  firewall { '150 forward port 80 to 443':
    table   => 'nat',
    chain   => 'PREROUTING',
    jump    => 'REDIRECT',
    proto   => 'tcp',
    dport   => 80,
    toports => 443
  }

  $defaults = {
    'action' => 'accept',
    proto    => 'tcp',
    state    => 'NEW',
  }

  # ports for services
  create_resources('firewall', $service_ports, $defaults)
}
