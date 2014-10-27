class site::worker_node (
  $cvmfs_cache_base        = $site::params::cvmfs_cache_base,
  $cvmfs_http_proxy        = $site::params::cvmfs_http_proxy,
  $cvmfs_mounts            = {
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
  $cvmfs_quota_limit       = $site::params::cvmfs_quota_limit,
  $cvmfs_server_url        = $site::params::cvmfs_server_url,
  $is_arc_ce_worker_node   = false,
  $is_hadoop_worker_node   = false,
  $is_htcondor_worker_node = false,
  $is_torque_worker_node   = false,
  $is_tier_two_worker_node = false,
  $java_jdk_version        = undef,) inherits site::params {
  # special configuration for grid connected worker nodes
  if ($is_arc_ce_worker_node == true or $is_tier_two_worker_node == true) {
    # which files to use for site configuration
    if ($is_arc_ce_worker_node) {
      $site_local_config = 'puppet:///modules/site/site-local-config.T2.xml'
      $storage_xml       = 'puppet:///modules/site/storage.T2.xml'
    } else { # tier two
      $site_local_config = 'puppet:///modules/site/site-local-config.T2.xml'
      $storage_xml       = 'puppet:///modules/site/storage.T2.xml'
    }
  }

  ################################################
  # CVMFS should be available on all worker nodes
  ################################################
  class { 'site::cvmfs_config':
    cvmfs_quota_limit => $cvmfs_quota_limit,
    cvmfs_http_proxy  => $cvmfs_http_proxy,
    cvmfs_server_url  => $cvmfs_server_url,
    cvmfs_cache_base  => $cvmfs_cache_base,
    cvmfs_mounts      => $cvmfs_mounts,
    site_local_config => $site_local_config,
    storage_xml       => $storage_xml,
  }

  if ($is_arc_ce_worker_node == true) {
    package { 'HEP_OSlibs_SL6': ensure => installed }
  }
}
