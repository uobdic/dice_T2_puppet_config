class site::basic_user (
  $user_accounts = $site::params::user_accounts,
  $user_groups   = $site::params::user_groups,) inherits site::params {
  package { 'pam_krb5': ensure => present, }

  file { '/etc/krb5.conf':
    ensure => present,
    source => 'puppet:///modules/site/krb5.conf',
  }

  class { 'site::create_groups':
    groups => $user_groups,
  }

  class { 'site::create_accounts':
    accounts => $user_accounts,
  }

  Package['pam_krb5'] -> File['/etc/krb5.conf'] -> Class['site::create_groups'] 
  -> Class['site::create_accounts']
}