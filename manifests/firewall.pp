class site::firewall (
  $rules = {
  }
) {
  $ipv4_file      = $operatingsystem ? {
    'debian'          => '/etc/iptables/rules.v4',
    /(RedHat|CentOS)/ => '/etc/sysconfig/iptables',
    default           => '/etc/sysconfig/iptables',
  }

  # for readability and to keep lines below 80 characters (puppet-lint)
  $flush_tables   = 'iptables -F'
  $save_tables    = "iptables-save > $ipv4_file"
  $restart_tables = 'service iptables restart'
  $search_for     = 'Firewall configuration written by'

  exec { 'purge default firewall':
    command => "$flush_tables && $save_tables && $restart_tables",
    onlyif  => "test `grep \"$search_for\" $ipv4_file | wc -l` -gt 0",
    path    => [
      '/sbin',
      '/usr/bin'],
    user    => 'root',
  }

  resources { 'firewall': purge => true }

  Firewall {
    before  => Class['site::firewall::post'],
    require => Class['site::firewall::pre'],
  }

  create_resources('firewall', $rules)
}
