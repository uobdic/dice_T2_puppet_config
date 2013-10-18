class site::worker_node_t2 {
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
  file { '/opt/cvmfs/cms.cern.ch/SITECONF/local/JobConfig/site-local-config.xml':
    ensure => present,
    source => 'puppet:///modules/site/site-local-config.T2.xml',
  }
}
