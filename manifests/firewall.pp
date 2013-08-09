class site::firewall (
  $rules = {
  }
) {
  $ipv4_file = $operatingsystem ? {
    "debian"          => '/etc/iptables/rules.v4',
    /(RedHat|CentOS)/ => '/etc/sysconfig/iptables',
    default           => '/etc/sysconfig/iptables',
  }

  exec { "purge default firewall":
    command => "/sbin/iptables -F && /sbin/iptables-save > $ipv4_file && /sbin/service iptables restart",
    onlyif  => "/usr/bin/test `/bin/grep \"Firewall configuration written by\" $ipv4_file | /usr/bin/wc -l` -gt 0",
    user    => 'root',
  }

  resources { "firewall": purge => true }

  Firewall {
    before  => Class['site::firewall::post'],
    require => Class['site::firewall::pre'],
  }

  create_resources('firewall', $rules)
}
