class site::basic (
  $cluster = $site::params::cluster, 
  $yum_repositories = [],
  $nameserver = [], 
  $search = [],
  $packages = $site::params::basic_packages,
) inherits site::params {

  #############################
  # yum repositories
  #############################
  class { 'site::yum_repositories':
    repositories => $yum_repositories,
  }

  #############################
  # to be moved to puppet module
  #############################
  package { 'puppet': ensure => installed, }

  service { 'puppet':
    ensure => "running",
    enable => true,
  }

  file { '/etc/puppet/puppet.conf':
    notify  => Service["puppet"],
    mode    => 644,
    owner   => "root",
    group   => "root",
    ensure  => "present",
    content => template("site/puppet.conf.erb"),
    require => Package["puppet"],
  }

  file { '/etc/puppet/auth.conf':
    notify  => Service["puppet"],
    mode    => 644,
    owner   => "root",
    group   => "root",
    ensure  => "present",
    source  => "puppet:///modules/site/auth.conf",
    require => Package["puppet"],
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
    mode    => 644,
    owner   => "root",
    group   => "root",
    ensure  => "present",
    source  => "puppet:///modules/site/bash_profile",
    require => Package["puppet"],
  }

  class { 'site::resolvconf':
    nameserver => $nameserver,
    search     => $search,
  }

  file { '/etc/sysconfig/network':
    mode    => 644,
    owner   => "root",
    group   => "root",
    ensure  => "present",
    content => template("${module_name}/network.erb"),
  }
}
