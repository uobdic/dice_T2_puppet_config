class site::firewall::tiertwo {
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
}