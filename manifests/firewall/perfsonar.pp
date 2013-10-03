class site::firewall::perfsonar (
  $type = 'latency') {
  firewall { '200 For the web service interface':
    proto  => tcp,
    action => accept,
    port   => [
      80,
      443,
      ],
  }

  firewall { '201 SNMP MA':
    proto  => tcp,
    action => accept,
    port   => [
      8065,
      9990,
      ],
  }

  firewall { '202 traceroute MA':
    proto  => [
      tcp,
      udp,
      icmp,
      ],
    action => accept,
    port   => [
      8086,
      8087,
      ],
  }

  firewall { '203 PingER':
    proto  => [
      tcp,
      imcp,
      ],
    action => accept,
    port   => 8075,
  }

  firewall { '204 perfSONAR-BUOY':
    proto  => tcp,
    action => accept,
    port   => [
      8085,
      8569,
      8570,
      ],
  }

  firewall { '205 Lookup service':
    proto  => tcp,
    action => accept,
    port   => [
      8090,
      8095,
      9995,
      ],
  }

  firewall { '206 BWCTL':
    proto  => tcp,
    action => accept,
    port   => 4823,
  }

  firewall { '207 BWCTL':
    proto  => [
      tcp,
      udp,
      ],
    action => accept,
    dport  => '6001-6200',
  }

  firewall { '208 BWCTL':
    proto  => [
      tcp,
      udp,
      ],
    action => accept,
    dport  => '5001-5600',
  }

  firewall { '209 OWAMP':
    proto  => tcp,
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
}
