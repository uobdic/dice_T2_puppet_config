class site::backup::config inherits site::params {
  file { '/.nsr':
    notify  => Service["networker"],
    source  => "puppet:///modules/${module_name}/nsr",
    require => [
      Package['lgtoclnt'],
      Package['lgtoman']],
  }

  $major_release = $site::params::major_release

  if $major_release == 6 {
    file { '/etc/syslog.conf':
      ensure  => 'link',
      target  => '/etc/rsyslog.conf',
      require => [
        Package['lgtoclnt'],
        Package['lgtoman']],
    }
  }

  # TODO: remove daemon.notice /nsr/logs/messages from /etc/syslog.conf
}
