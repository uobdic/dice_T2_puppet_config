class site::firewall::post {
  # after pre, before custom rules
  firewall { '199 Reject anything else':
    chain  => 'FORWARD',
    proto  => 'all',
    action => 'reject',
    reject => 'icmp-host-prohibited',
  }

  # after everything
  firewall { '9997 Log once all DROPs are done':
    proto      => 'all',
    jump       => 'LOG',
    log_prefix => '[iptables]: '
  }

  firewall { '9998 Reject anything else':
    proto  => 'all',
    action => 'reject',
    reject => 'icmp-host-prohibited',
  }

}
