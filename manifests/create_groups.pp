class site::create_groups ($groups = $site::params::user_groups) inherits site::params {
  $defaults = {
    'ensure' => present,
  }
  create_resources(group, $groups, $defaults)
}