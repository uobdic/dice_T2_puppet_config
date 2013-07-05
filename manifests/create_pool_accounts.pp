class site::create_pool_accounts (
  $account_prefix       = 'puppettest',
  $account_number_start = 0,
  $account_number_end   = 1,
  $user_ID_number_start = 90000,
  $user_ID_number_end   = 90001,
  $groups               = ['puppettesting'],
  $users                = undef,
  $create_home_dir      = true) {
  $defaults = {
    'ensure'       => present,
    'shell'        => "/bin/bash",
    'password'     => "*NP*",
    'create_group' => false,
    'manage_home'  => $create_home_dir,
  }

  if $users != undef {
    create_resources('account', $users, $defaults)
  } else {
    notify { 'This functionality is not yet available.': }
  }
}