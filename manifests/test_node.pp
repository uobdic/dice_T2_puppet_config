class site::test_node (
  $cluster           = $site::params::cluster,
  $nameserver        = [],
  $search            = [],
  $cvmfs_version     = $site::params::cvmfs_version,
  $cvmfs_quota_limit = $site::params::cvmfs_quota_limit,
  $cvmfs_http_proxy  = $site::params::cvmfs_http_proxy,
  $cvmfs_server_url  = $site::params::cvmfs_server_url,
  $cvmfs_cache_base  = $site::params::cvmfs_cache_base,
  $java_jdk_version  = undef,
  $yum_repositories = [],) inherits site::params {

  if ($java_jdk_version) {
    package { 'jdk':
      ensure  => $java_jdk_version,
      require => Yumrepo['bristol'],
    }
  }

  #############################
  # yum repositories
  #############################
  class{'site::yum_repositories':
    repositories => $yum_repositories,
  }

}
