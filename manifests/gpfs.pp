class site::gpfs {
  tag 'gpfs'

  # dependecies
  # more under https://wikis.bris.ac.uk/display/BristolT2/GPFS
  package { [
    'kernel-headers',
    'kernel-devel',
    'cpp',
    'gcc',
    'gcc-c++',
    'compat-libstdc++-33',
    'libstdc++',
    'rsh',
    'ksh']:
    ensure => latest,
    tag    => 'gpfs_dependencies',
  }
  # install GPFS
  $gpfs_source = 'http://dice-vm-37-00.acrc.bris.ac.uk/yum/bristol'

  file { '/etc/init.d/gpfs_recompile':
    source => 'puppet:///modules/site/gpfs_recompile',
    mode   => '0775',
  }

  service { 'gpfs_recompile':
    # doesn't need to be running
    ensure     => stopped,
    # run at boot
    enable     => true,
    hasrestart => false,
    hasstatus  => false,
    require    => [File['/etc/init.d/gpfs_recompile']],
  }

}
