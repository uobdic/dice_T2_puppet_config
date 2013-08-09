class site::basic (
  $cluster = $site::params::cluster,
  $yum_repositories = [],
  $nameserver = [],
  $search = [],
  $packages = {
    'nano' => {},
    'yum' => {},
    'git' => {},
    'wget' => {},
    'mlocate' => {},
  },
  $firewall_rules = {},
  $use_firewall = false,
) inherits site::params {

  File {#defaults for files
    mode   => 644,
    owner  => 'root',
    group  => 'root',
    ensure => 'present',
  }

  #############################
  # yum repositories
  #############################
  class { 'site::yum_repositories':
    repositories => $::yum_repositories,
  }

  #############################
  # to be moved to puppet module
  #############################
  package { 'puppet': ensure => latest, }

  service { 'puppet':
    ensure => 'running',
    enable => true,
  }

  file { '/etc/puppet/puppet.conf':
    notify  => Service['puppet'],
    content => template('site/puppet.conf.erb'),
    require => Package['puppet'],
  }

  file { '/etc/puppet/auth.conf':
    notify  => Service['puppet'],
    source  => 'puppet:///modules/site/auth.conf',
    require => Package['puppet'],
  }

  #############################
  # basic packages
  #############################
  motd::file { 'mine': template => "site/motd_${cluster}.erb" }

  $package_defaults = {
    'ensure' => installed,
  }
  create_resources('package', $::packages, $package_defaults)

  file { '/root/.bash_profile':
    source  => 'puppet:///modules/site/bash_profile',
    require => Package['puppet'],
  }

  class { 'site::resolvconf':
    nameserver => $::nameserver,
    search     => $::search,
  }


  if $::use_firewall == true {
    class { 'site::firewall': rules => $::firewall_rules, }
  }
}
