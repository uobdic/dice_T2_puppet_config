class site::worker_node inherits site::params {
  require cvmfs

  #  class {'cvmfs:'}
  cvmfs::mount { 'lhcb.cern.ch': cvmfs_quota_limit => 20000}

  cvmfs::mount { 'atlas.cern.ch': cvmfs_quota_limit => 20000 }

  cvmfs::mount { 'cms.cern.ch': cvmfs_quota_limit => 20000 }
  
  cvmfs::mount { 'grid.cern.ch': cvmfs_quota_limit => 1000 }
}