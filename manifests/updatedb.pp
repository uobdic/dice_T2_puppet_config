class site::updatedb () {
package {'mlocate' : ensure => installed }
file { '/etc/updatedb.conf':
      source  => 'puppet:///modules/site/updatedb.conf',
      require => Package['mlocate'],
    }
}
