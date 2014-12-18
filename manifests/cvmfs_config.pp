class site::cvmfs_config (
  $cvmfs_cache_base  = $site::params::cvmfs_cache_base,
  $cvmfs_http_proxy  = $site::params::cvmfs_http_proxy,
  $cvmfs_mounts      = {
    'atlas.cern.ch'     => {
      cvmfs_quota_limit   => 20000
    }
    ,
    'cms.cern.ch'       => {
      cvmfs_quota_limit   => 20000,
      cvmfs_env_variables => {
        'CMS_LOCAL_SITE'    => '/opt/cvmfs/cms.cern.ch/SITECONF/local'
      }
    }
    ,
    'grid.cern.ch'      => {
      cvmfs_quota_limit   => 1000
    }
    ,
    'lhcb.cern.ch'      => {
      cvmfs_quota_limit   => 20000
    }
  }
  ,
  $cvmfs_quota_limit = $site::params::cvmfs_quota_limit,
  $cvmfs_server_url  = $site::params::cvmfs_server_url,
  $cvmfs_version     = $site::params::cvmfs_version,
  $site_local_config = 'puppet:///modules/site/site-local-config.T2.xml',
  $storage_xml       = 'puppet:///modules/site/storage.T2.xml',) {
  ################################################
  # CVMFS should be available on all worker nodes
  # For now disabled for T2
  ################################################
  class { 'cvmfs':
    cvmfs_quota_limit => $cvmfs_quota_limit,
    cvmfs_http_proxy  => $cvmfs_http_proxy,
    cvmfs_cache_base  => $cvmfs_cache_base,
  }
  $defaults = {
    'cvmfs_server_url' => $cvmfs_server_url,
  }
  create_resources('cvmfs::mount', $cvmfs_mounts)

  # create folder structure for local site configuration
  file { [
    '/opt/cvmfs',
    '/opt/cvmfs/cms.cern.ch',
    '/opt/cvmfs/cms.cern.ch/SITECONF',
    '/opt/cvmfs/cms.cern.ch/SITECONF/local',
    '/opt/cvmfs/cms.cern.ch/SITECONF/local/JobConfig',
    '/opt/cvmfs/cms.cern.ch/SITECONF/local/PhEDEx',
    ]:
    ensure => directory,
  } ->
  file { '/opt/cvmfs/cms.cern.ch/SITECONF/local/JobConfig/site-local-config.xml'
  :
    ensure => present,
    source => $site_local_config,
  } ->
  file { '/opt/cvmfs/cms.cern.ch/SITECONF/local/PhEDEx/storage.xml':
    ensure => present,
    source => $storage_xml,
  }
}
