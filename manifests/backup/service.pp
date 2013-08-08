class site::backup::service inherits site::params {
  service { 'networker':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [
      Package['lgtoclnt'],
      Package['lgtoman']]
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
    require    => [
      Package['lgtoclnt'],
      Package['lgtoman']]
  }

}
