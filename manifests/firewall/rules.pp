class site::firewall::rules (
  $firewall_rules = {
  }
  ,) {
  create_resources('firewall', $firewall_rules)
}