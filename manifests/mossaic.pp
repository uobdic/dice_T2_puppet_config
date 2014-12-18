class site::mossaic (
  $version = 'trunk') {
  # create mossaic account
  account { 'mossaic':
    home_dir    => '/opt/mossaic',
    manage_home => true,
  }

  # install packages
  $packages = [
    'bzip2-devel',
    'gcc',
    'make',
    'nano',
    'openssl-devel',
    'patch',
    'unzip',
    'wget',
    'zlib-devel',
    ]

  package { $packages: ensure => present, }
}
