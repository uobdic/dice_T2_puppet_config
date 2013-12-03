class site::worker_node (
  $cvmfs_version           = $site::params::cvmfs_version,
  $cvmfs_quota_limit       = $site::params::cvmfs_quota_limit,
  $cvmfs_http_proxy        = $site::params::cvmfs_http_proxy,
  $cvmfs_server_url        = $site::params::cvmfs_server_url,
  $cvmfs_cache_base        = $site::params::cvmfs_cache_base,
  $is_arc_ce_worker_node   = false,
  $is_hadoop_worker_node   = false,
  $is_htcondor_worker_node = false,
  $is_torque_worker_node   = false,
  $is_tier_two_worker_node = false,
  $java_jdk_version        = undef,) inherits site::params {
  ################################################
  # CVMFS should be available on all worker nodes
  # For now disabled for T2
  ################################################
  if ($is_tier_two_worker_node == false) {
    class { 'cvmfs::install': cvmfs_version => $cvmfs_version, }

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

    cvmfs::mount { 'cms.cern.ch':
      cvmfs_quota_limit   => 20000,
      cvmfs_env_variables => {
        'CMS_LOCAL_SITE' => '/opt/cvmfs/cms.cern.ch/SITECONF/local'
      }
      ,
      require             => [
        File['/opt/cvmfs/cms.cern.ch/SITECONF/local/JobConfig/site-local-config.xml'
          ],
        File['/opt/cvmfs/cms.cern.ch/SITECONF/local/PhEDEx/storage.xml'],
        ]
    }

    cvmfs::mount { 'grid.cern.ch': cvmfs_quota_limit => 1000 }
  }

  # special configuration for grid connected worker nodes
  if ($is_arc_ce_worker_node == true or $is_tier_two_worker_node == true) {
    # which files to use for site configuration
    if ($is_arc_ce_worker_node) {
      $site_local_config = 'puppet:///modules/site/site-local-config.xml'
      $storage_xml = 'puppet:///modules/site/storage.xml'
    } else { # tier two
      $site_local_config = 'puppet:///modules/site/site-local-config.T2.xml'
      $storage_xml = 'puppet:///modules/site/storage.T2.xml'
    }

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

  if ($is_arc_ce_worker_node == true) {
    # create directories
    file { [
      '/etc/arc/',
      '/etc/arc/runtime/',
      '/etc/arc/runtime/ENV']:
      ensure => directory,
    } ->
    file { '/etc/arc/runtime/ENV/GLITE':
      ensure => present,
      source => 'puppet:///modules/site/GLITE',
    } ->
    file { '/etc/arc/runtime/ENV/PROXY':
      ensure => present,
      source => 'puppet:///modules/site/PROXY',
    }
  }

  if ($is_hadoop_worker_node == true and $java_jdk_version) {
    package { 'jdk':
      ensure  => $java_jdk_version,
      require => Yumrepo['bristol'],
    }
  }
}
