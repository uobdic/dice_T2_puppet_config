class site::reverse_proxy (
  $service_ports = {
  }
) {
  firewall { '150 forward port 80 to 443':
    table   => 'nat',
    chain   => 'PREROUTING',
    jump    => 'REDIRECT',
    proto   => 'tcp',
    iniface => 'em2',
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
