class site::reverse_proxy {
  firewall { '101 forward port 80 to 8000':
    table   => 'nat',
    chain   => 'PREROUTING',
    jump    => 'REDIRECT',
    proto   => 'tcp',
    dport   => 80,
    toports => 443
  }

  firewall { '100 snat for network DICe':
    chain    => 'POSTROUTING',
    jump     => 'MASQUERADE',
    proto    => 'all',
    outiface => "em2",
    source   => '10.132.0.0/16',
    table    => 'nat',
  }
  
  firewall { '101 snat for network DICe':
    chain    => 'POSTROUTING',
    jump     => 'SNAT',
    proto    => 'all',
    outiface => "em2",
    tosource => '10.132.0.0/16',
    table    => 'nat',
  }
}