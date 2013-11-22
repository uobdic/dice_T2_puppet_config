class site::backup::firewall {
  firewall { '200 For UoB IS backups':
    action => 'accept',
    proto  => ['tcp', 'udp'],
    source => '137.222.10.17',
    state  => 'NEW',
    dport  => '7937-9936',
    notify => Service['networker'], # restart networker after applying this
                                    # firewall rule
  }

  firewall { '201 For UoB IS backups':
    action => 'accept',
    proto  => ['tcp', 'udp'],
    source => '137.222.9.60',
    state  => 'NEW',
    dport  => '7937-9936',
    notify => Service['networker'], # restart networker after applying this
                                    # firewall rule
  }
}
