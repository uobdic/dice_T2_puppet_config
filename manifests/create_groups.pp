class site::create_groups($groups = $site::params::user_groups) inherits site::params {
  create_resources(group, $groups)
}