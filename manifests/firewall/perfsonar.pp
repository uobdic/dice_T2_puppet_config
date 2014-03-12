class site::firewall::perfsonar (
  $type    = 'latency',
  $open_to = [
    '188.184.0.0/15',
    '128.142.0.0/16',
    '137.138.0.0/17',
    '137.222.10.36',
    '192.41.231.110'],) {

  firewall { '201 SNMP MA':
    proto  => tcp,
    action => accept,
    port   => [8065, 9990,],
  }

  firewall { '202 traceroute MA':
    proto  => [tcp, udp, icmp,],
    action => accept,
    port   => [8086, 8087,],
  }

  firewall { '203 PingER - tcp':
    proto  => tcp,
    action => accept,
    port   => 8075,
  }

  firewall { '203 PingER - icmp':
    proto  => icmp,
    action => accept,
  }

  firewall { '204 perfSONAR-BUOY':
    proto  => tcp,
    action => accept,
    port   => [8085, 8569, 8570,],
  }

  firewall { '205 Lookup service':
    proto  => tcp,
    action => accept,
    port   => [8090, 8095, 9995,],
  }

  firewall { '206 BWCTL':
    proto  => tcp,
    action => accept,
    port   => 4823,
  }

  firewall { '207 BWCTL':
    proto  => [tcp, udp,],
    action => accept,
    dport  => '6001-6200',
  }

  firewall { '208 BWCTL':
    proto  => [tcp, udp,],
    action => accept,
    dport  => '5001-5600',
  }

  firewall { '209 owamp control - tcp':
    proto  => tcp,
    action => accept,
    port   => 861,
  }

  firewall { '209 owamp control - udp':
    proto  => udp,
    action => accept,
    port   => 861,
  }

  firewall { '210 OWAMP':
    proto  => udp,
    action => accept,
    dport  => '8760-9960',
  }

  firewall { '211 NDT':
    proto  => tcp,
    action => accept,
    dport  => '3001-3003',
  }

  firewall { '212 NDT':
    proto  => tcp,
    action => accept,
    port   => 7123,
  }

  firewall { '213 NPAD':
    proto  => tcp,
    action => accept,
    dport  => '8000-8020',
  }

  # need to open 80 and 443 to trusted networks
  $ports = [80, 443]
  firewall { '220 For the web service interface S1':
    proto  => tcp,
    action => accept,
    port   => $ports,
    source => '188.184.0.0/15',
  }

  firewall { '220 For the web service interface S2':
    proto  => tcp,
    action => accept,
    port   => $ports,
    source => '128.142.0.0/16',
  }

  firewall { '220 For the web service interface S3':
    proto  => tcp,
    action => accept,
    port   => $ports,
    source => '137.138.0.0/17',
  }

  firewall { '220 For maddash.aglt2.org':
    proto  => tcp,
    action => accept,
    port   => $ports,
    source => '137.222.10.36',
  }

  firewall { '220 For Nagios':
    proto  => tcp,
    action => accept,
    port   => $ports,
    source => '192.41.231.110',
  }
}
