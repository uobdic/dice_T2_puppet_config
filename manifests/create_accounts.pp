class site::create_accounts ($accounts = undef) {
  $defaults = {
    'ensure' => present,
    'shell' => "/bin/bash",
    'password' => "!!",
    'create_group' => false,
  }
  create_resources('account', $accounts, $defaults)
}
