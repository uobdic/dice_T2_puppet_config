class site::backup::firewall {
  firewall { '200 For UB IS backups':
    action => 'accept',
    proto  => 'all',
    source => '137.222.10.17',
    state  => 'NEW',
    dport  => '7937-9936',
    notify => Service['networker'], # restart networker after applying this
                                    # firewall rule
  }
}