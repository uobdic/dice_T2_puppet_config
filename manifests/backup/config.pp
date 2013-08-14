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

  $search_for = 'daemon.notice'
  exec { 'remove daemon.notice /nsr/logs/messages from /etc/(r)syslog.conf':
    command => "sed -i \'s/$search_for/#$search_for/g\' /etc/syslog.conf",
    onlyif  => [
      # find daemon.notice
      "test `grep -c \"$search_for\" /etc/syslog.conf` -gt 0",
      # not commented out yet
      "test `grep -c \"#$search_for\" /etc/syslog.conf` -eq 0"],
    path    => [
      '/sbin',
      '/usr/bin'],
    user    => 'root',
  } -> Service[$site::params::syslog] #restart syslog after making these changes

}
