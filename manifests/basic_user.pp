class site::basic_user (
  $user_accounts = $site::params::user_accounts,
  $user_groups = $site::params::user_groups,
) inherits site::params {
  
  class{'site::create_groups':
    groups => $user_groups,
  }
  
  class{'site::create_accounts':
    accounts => $user_accounts,
  }
  
  Class['site::create_groups'] -> Class['site::create_accounts'] 
}