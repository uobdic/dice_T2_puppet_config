class site::firewall::hep {
  firewall { '100 Trust UoB network':
    proto  => 'all',
    action => 'accept',
    source => '137.222.0.0/16',
  }

  firewall { '101 drop all-systems.mcast.net':
    proto       => 'igmp',
    action      => 'drop',
    destination => '224.0.0.1',
  }
  
  firewall { '100 Trust DICE network':
    proto  => 'all',
    action => 'accept',
    source => '10.132.0.0/16',
  }
  
  firewall { '100 Trust SM network':
    proto  => 'all',
    action => 'accept',
    source => '10.129.1.0/24',
  }
}
