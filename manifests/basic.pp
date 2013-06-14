class site::basic (
  $cluster = $site::params::cluster, 
  $nameserver = [], 
  $search = [],
) inherits site::params {
  package { 'puppet': ensure => installed, }

  #############################
  # to be moved to puppet module
  #############################
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

  package { "nano": ensure => installed }

  package { "git": ensure => installed }

  file { '/root/.bash_profile':
    mode    => 644,
    owner   => "root",
    group   => "root",
    ensure  => "present",
    source  => "puppet:///modules/site/bash_profile",
    require => Package["puppet"],
  }
  
  class{'resolvconf':
    nameserver => $nameserver,
    search => $search,
  }
}