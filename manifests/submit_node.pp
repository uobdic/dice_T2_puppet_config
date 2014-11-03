class site::submit_node (
  $cvmfs_cache_base  = $site::params::cvmfs_cache_base,
  $cvmfs_http_proxy  = $site::params::cvmfs_http_proxy,
  $cvmfs_mounts      = {
    'atlas.cern.ch'     => {
      cvmfs_quota_limit   => 1000
    }
    ,
    'cms.cern.ch'       => {
      cvmfs_quota_limit   => 5000,
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
      cvmfs_quota_limit   => 5000
    }
  }
  ,
  $cvmfs_quota_limit = $site::params::cvmfs_quota_limit,
  $cvmfs_server_url  = $site::params::cvmfs_server_url,) {
  class { 'concat::setup' : }
  class { 'site::cvmfs_config':
    cvmfs_quota_limit => $cvmfs_quota_limit,
    cvmfs_http_proxy  => $cvmfs_http_proxy,
    cvmfs_server_url  => $cvmfs_server_url,
    cvmfs_cache_base  => $cvmfs_cache_base,
    cvmfs_mounts      => $cvmfs_mounts,
  }

  package { ['emi-ui', 'krb5-workstation']: ensure => latest, }

  package { 'HEP_OSlibs_SL6': ensure => installed }

  file { [
    '/condor',
    '/condor/bin']: ensure => directory }

  file { '/condor/bin/condor_submit':
    ensure  => present,
    content => template('site/condor_submit.erb'),
    mode    => 'a+rx,ug+rw',
  }

  # put script to set /condor/bin before any other path in $PATH
  file { '/etc/profile.d/condor.sh':
    ensure => present,
    source => 'puppet:///modules/site/condor.sh',
  }
}
