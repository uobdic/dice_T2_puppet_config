class site::fstab ($mounts = undef) inherits site::params {
  if ($mounts) {
    $defaults = {
      ensure => 'mounted',
      target => '/etc/fstab'
    }

    create_resources(mount, $mounts, $defaults)
  }
}