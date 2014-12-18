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

  if ($::node_type == 'vm-guest' or $::node_type == 'worker') {
    $defaults = {
      'ensure'       => present,
      'shell'        => '/bin/bash',
      'password'     => '!!',
      'create_group' => false,
    }
  } else {
    # no login allowed!
    $defaults = {
      'ensure'       => present,
      'shell'        => '/sbin/nologin',
      'password'     => '!!',
      'create_group' => false,
    }
  }

  create_resources('account', $users, $defaults)

}
