class site::create_pool_accounts (
  $account_prefix       = 'puppettest',
  $account_number_start = 0,
  $account_number_end   = 1,
  $user_ID_number_start = 90000,
  $user_ID_number_end   = 90001,
  $primary_group        = undef,
  $groups               = ['puppettesting'],
  $users                = undef,
  $create_home_dir      = true) {
  $defaults = {
    'manage_home' => $create_home_dir,
    'groups'      => $groups,
    'primary_group' => $primary_group,
  }

  if $users != undef {
    create_resources('pool_account', $users, $defaults)
  } else {
    notify { 'This functionality is not yet available.': }
  }
}