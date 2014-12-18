# Base class is the new basic
class site::base (
  $cluster              = 'None',
  $packages             = ['nano', 'wget'],
  $puppet_version       = 'latest',
  $remove_packages      = [],
  $yum_exclude_packages = [],
  $yum_proxy            = undef,
  $yum_repositories     = {
  }
  ,) {
  # defaults for files
  File {
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    ensure => 'present',
  }

  #############################
  # Puppet
  #############################
  # install puppet
  package { 'puppet':
    ensure => $puppet_version,
    notify => Service['puppet'],
  }

  # ensure the service is running and in chkconfig
  service { 'puppet':
    ensure  => 'running',
    enable  => true,
    require => Package['puppet'],
  }

  # send configuration files
  #  file { '/etc/puppet/puppet.conf':
  #    notify  => Service['puppet'],
  #    content => template('site/puppet.conf.erb'),
  #    require => Package['puppet'],
  #  }

  file { '/etc/puppet/auth.conf':
    notify  => Service['puppet'],
    source  => 'puppet:///modules/site/auth.conf',
    require => Package['puppet'],
  }

  #############################
  # yum repositories
  #############################
  $defaults = {
    'enabled'  => 1,
    'gpgcheck' => 1,
  }
  create_resources('yumrepo', $yum_repositories, $defaults)

  #############################
  # basic packages
  #############################
  package { $packages: ensure => installed, }

  package { $remove_packages: ensure => absent, }

  if ($cluster == 'DICE') {

  }

  # bash_profile for useful aliases etc.
  file { '/root/.bash_profile':
    source  => 'puppet:///modules/site/bash_profile',
    require => Package['puppet'],
  }

  # so far only for DICE
  if $cluster == 'DICE' {
    file { '/etc/yum.conf': content => template("${module_name}/yum.conf.erb"),
    }

    # Message of the day
    class { 'motd':
      default_template => "site/motd_${cluster}.erb"
    }

    # for now this is needed
    motd::file { 'mine': template => "site/motd_${cluster}.erb" }

    service { 'rsyslog':
      ensure  => 'running',
      enable  => true,
      require => Package['rsyslog'],
    }

    package { 'rsyslog': ensure => installed }

    if 'vm-37-' in $::fqdn {
      $rsyslog_file = 'puppet:///modules/site/rsyslog.conf.central_log'
    } else {
      $rsyslog_file = 'puppet:///modules/site/rsyslog.conf'
    }

    file { '/etc/rsyslog.conf':
      notify => Service['rsyslog'],
      source => $rsyslog_file,
    }

  }
}
