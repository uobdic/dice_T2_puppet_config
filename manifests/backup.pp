class site::backup {
  class { 'site::backup::install': }

  class { 'site::backup::config': }

  class { 'site::backup::service': }

  Class['site::backup::install'] -> Class['site::backup::config'] -> Class['site::backup::service']
}
