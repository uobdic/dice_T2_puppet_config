class site::worker_node (
  $cvmfs_version     = $site::params::cvmfs_version,
  $cvmfs_quota_limit = $site::params::cvmfs_quota_limit,
  $cvmfs_http_proxy  = $site::params::cvmfs_http_proxy,
  $cvmfs_server_url  = $site::params::cvmfs_server_url,
  $cvmfs_cache_base  = $site::params::cvmfs_cache_base,
  $java_jdk_version  = undef,) inherits site::params {
  ##################
  # CVMFS
  ##################
  class { 'cvmfs::install':
    cvmfs_version => $cvmfs_version,
  }

  class { 'cvmfs::config':
    cvmfs_quota_limit => $cvmfs_quota_limit,
    cvmfs_http_proxy  => $cvmfs_http_proxy,
    cvmfs_server_url  => $cvmfs_server_url,
    cvmfs_cache_base  => $cvmfs_cache_base,
  }

  class { 'cvmfs::service':
  }

  cvmfs::mount { 'lhcb.cern.ch': cvmfs_quota_limit => 20000 }

  cvmfs::mount { 'atlas.cern.ch': cvmfs_quota_limit => 20000 }

  cvmfs::mount { 'cms.cern.ch': cvmfs_quota_limit => 20000 }

  cvmfs::mount { 'grid.cern.ch': cvmfs_quota_limit => 1000 }

  if ($java_jdk_version) {
    package { 'jdk':
      ensure  => $java_jdk_version,
      require => Yumrepo['bristol'],
    }
  }
}
