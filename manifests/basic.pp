class site::basic (
  $cluster = $site::params::cluster,
  $yum_repositories = {},
  $nameserver = [],
  $search = [],
  $packages = {
    'nano' => {},
    'yum' => {},
    'git' => {},
    'wget' => {},
    'mlocate' => {},
    'bind-utils' => {},
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

  class{'site::puppet': }

  #############################
  # yum repositories
  #############################
  class { 'site::yum_repositories':
    repositories => $yum_repositories,
  }

  #############################
  # basic packages
  #############################
  motd::file { 'mine': template => "site/motd_${cluster}.erb" }

  $package_defaults = {
    'ensure' => installed,
  }
  create_resources('package', $packages, $package_defaults)

  file { '/root/.bash_profile':
    source  => 'puppet:///modules/site/bash_profile',
    require => Package['puppet'],
  }

  class { 'site::network::resolvconf':
    nameserver => $nameserver,
    search     => $search,
  }


  if $use_firewall == true {
    class { 'site::firewall': rules => $firewall_rules, }
  }

  if $cluster == 'DICE' {
    file { '/etc/rc.local':
      ensure => present,
      source => 'puppet:///modules/site/rc.local',
    }

    file {'/etc/hosts':
      ensure => present,
      source => 'puppet:///modules/site/hosts',}
  }
}
