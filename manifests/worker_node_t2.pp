class site::worker_node_t2 (
  $cvmfs_version     = $site::params::cvmfs_version,
  $cvmfs_quota_limit = $site::params::cvmfs_quota_limit,
  $cvmfs_http_proxy  = $site::params::cvmfs_http_proxy,
  $cvmfs_server_url  = $site::params::cvmfs_server_url,
  $cvmfs_cache_base  = $site::params::cvmfs_cache_base,) inherits site::params {
  ##################
  # CVMFS
  ##################
#  class { 'cvmfs::install':
#    cvmfs_version => $cvmfs_version,
#  }
#
#  class { 'cvmfs::config':
#    cvmfs_quota_limit => $cvmfs_quota_limit,
#    cvmfs_http_proxy  => $cvmfs_http_proxy,
#    cvmfs_server_url  => $cvmfs_server_url,
#    cvmfs_cache_base  => $cvmfs_cache_base,
#  }
#
#  class { 'cvmfs::service':
#  }
#
#  cvmfs::mount { 'lhcb.cern.ch': cvmfs_quota_limit => 20000 }
#
#  cvmfs::mount { 'atlas.cern.ch': cvmfs_quota_limit => 20000 }
#
#  cvmfs::mount { 'cms.cern.ch':
#    cvmfs_quota_limit   => 20000,
#    cvmfs_env_variables => {
#      'CMS_LOCAL_SITE' => '/opt/cvmfs/cms.cern.ch/SITECONF/local'
#    }
#    ,
#    require             => [
#      File['/opt/cvmfs/cms.cern.ch/SITECONF/local/JobConfig/site-local-config.xml'
#        ],
#      File['/opt/cvmfs/cms.cern.ch/SITECONF/local/PhEDEx/storage.xml'],
#      ]
#  }
#
#  cvmfs::mount { 'grid.cern.ch': cvmfs_quota_limit => 1000 }
#
#  file { [
#    '/opt/cvmfs',
#    '/opt/cvmfs/cms.cern.ch',
#    '/opt/cvmfs/cms.cern.ch/SITECONF',
#    '/opt/cvmfs/cms.cern.ch/SITECONF/local',
#    '/opt/cvmfs/cms.cern.ch/SITECONF/local/JobConfig',
#    '/opt/cvmfs/cms.cern.ch/SITECONF/local/PhEDEx',
#    ]:
#    ensure => directory,
#  } ->
#  file { '/opt/cvmfs/cms.cern.ch/SITECONF/local/JobConfig/site-local-config.xml'
#  :
#    ensure => present,
#    source => 'puppet:///modules/site/site-local-config.T2.xml',
#  } ->
#  file { '/opt/cvmfs/cms.cern.ch/SITECONF/local/PhEDEx/storage.xml':
#    ensure => present,
#    source => 'puppet:///modules/site/storage.T2.xml',
#  }
}
