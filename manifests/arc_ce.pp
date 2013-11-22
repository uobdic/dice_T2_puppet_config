class site::arc_ce ($enable_fixes = false) {
  file { [
    '/etc/arc/runtime/',
    '/etc/arc/runtime/ENV']: ensure => directory, } ->
  file { '/etc/arc/runtime/ENV/GLITE':
    ensure => present,
    source => 'puppet:///modules/site/GLITE',
  }

  if ($enable_fixes == true) {
    # # fixes
    # https://bugzilla.nordugrid.org/show_bug.cgi?id=3281
    file { '/usr/share/arc/submit-condor-job': source => 'puppet:///modules/site/fixes/submit-condor-job', 
    }
    #fix for the number of CPUs
    file { '/usr/share/arc/Condor.pm': source => 'puppet:///modules/site/fixes/Condor.pm', 
    }
    
  }

}
