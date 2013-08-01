class site::firewall (
  $rules) {
  resources { "firewall": purge => true }

  Firewall {
    before  => Class['site::firewall::post'],
    require => Class['site::firewall::pre'],
  }
}