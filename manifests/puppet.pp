class site::puppet {
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
}