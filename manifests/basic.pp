class dice_T2_puppet_config::basic {
  package {'puppet':
    ensure => installed,
  }
  
  service {'puppet':
    ensure => "running",
    enable => true,
  }
  
  file {'/etc/puppet/puppet.conf':
    notify  => Service["puppet"],
    mode    => 644,
    owner   => "root",
    group   => "root",
    ensure => "present",
    source => "puppet:///modules/site/puppet.conf",
    require => Package["puppet"],
  }
  
  
}