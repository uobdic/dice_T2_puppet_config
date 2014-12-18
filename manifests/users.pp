# Class: dice_T2_puppet_config::users
# class to simplify user management on DICE
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class site::users (
  $users  = {
  }
  ,
  $groups = {
  }
  ,) {
  $group_defaults = {
    'ensure' => present,
  }
  create_resources(group, $groups, $group_defaults)

  $defaults = {
    'ensure'       => present,
    'shell'        => '/bin/bash',
    'password'     => '!!',
    'create_group' => false,
  }

  if ($::node_type != 'vm-guest' and $::node_type != 'worker') {
    # no login allowed!
    $defaults['shell'] = '/sbin/nologin'
  }

  create_resources('account', $users, $defaults)

}
