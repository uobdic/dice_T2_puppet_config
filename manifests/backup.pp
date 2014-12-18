# Class: dice_T2_puppet_config::backup
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class site::backup inherits site::params {
  package { ['lgtoman', 'lgtoclnt']: ensure => present, }

  file { '/.nsr':
    notify  => Service['networker'],
    source  => "puppet:///modules/${module_name}/nsr",
    require => [Package['lgtoclnt'], Package['lgtoman']],
  }

  $major_release = $site::params::major_release

  if $major_release == 6 {
    file { '/etc/syslog.conf':
      ensure  => 'link',
      target  => '/etc/rsyslog.conf',
      require => [Package['lgtoclnt'], Package['lgtoman']],
    }
  }

  $search_for = 'daemon.notice'
  exec { 'remove daemon.notice /nsr/logs/messages from /etc/(r)syslog.conf':
    command => "sed -i \'s/${search_for}/#${search_for}/g\' /etc/syslog.conf",
    onlyif  => [
      # find daemon.notice
      "test `grep -c \"${search_for}\" /etc/syslog.conf` -gt 0",
      # not commented out yet
      "test `grep -c \"#${search_for}\" /etc/syslog.conf` -eq 0"],
    path    => ['/sbin', '/usr/bin'],
    user    => 'root',
  } -> Service[$site::params::syslog] # restart syslog after making these
                                      # changes



  service { 'networker':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [Package['lgtoclnt'], Package['lgtoman']]
  }

  # syslog
  $major_release = $site::params::major_release
  $syslog        = $major_release ? {
    '5'     => 'syslog',
    '6'     => 'rsyslog',
    default => 'syslog',
  }

  service { $syslog:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [Package['lgtoclnt'], Package['lgtoman']]
  }
}
