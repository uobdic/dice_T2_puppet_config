class site::glexec_worker (
  $argus_port         = '8154',
  $argus_server       = 'localhost',
  $emi_version        = 3,
  $glexec_location    = '/usr',
  $glexec_permissions = '4711',
  $glite_env_set      = true,
  $glite_location     = '/usr',
  $glite_location_var = '/var',
  $gridenvfile        = '/etc/profile.d/grid-env.sh',
  $gridmapdir         = '/etc/grid-security/gridmapdir',
  $grid_env_location  = '/usr/libexec',
  $gt_proxy_mode      = 'old',
  $install_dummydpm   = false,
  $install_emi_wn     = true,
  $myproxy_server     = 'localhost',
  $lcg_gfal_infosys   = 'unset',
  $lcg_location       = '/usr',
  $site_name          = 'EXAMPLE',
  $srm_path           = '',
  $supported_vos      = [],
  $vo_environments    = {
    'cms' => {
      'vo_sw_dir' => '/cvmfs/cms.cern.ch',
      'voname'    => 'cms',
    }
  }
  ,
  $default_se         = unset,
  $user_white_list    = ' ',) {
  class { 'glexecwn':
    argus_port         => $argus_port,
    argus_server       => $argus_server,
    emi_version        => $emi_version,
    glexec_location    => $glexec_location,
    glexec_permissions => $glexec_permissions,
    glite_env_set      => $glite_env_set,
    glite_location     => $glite_location,
    glite_location_var => $glite_location_var,
    gridenvfile        => $gridenvfile,
    gridmapdir         => $gridmapdir,
    grid_env_location  => $grid_env_location,
    gt_proxy_mode      => $gt_proxy_mode,
    install_dummydpm   => $install_dummydpm,
    install_emi_wn     => $install_emi_wn,
    myproxy_server     => $myproxy_server,
    lcg_gfal_infosys   => $lcg_gfal_infosys,
    lcg_location       => $lcg_location,
    site_name          => $site_name,
    srm_path           => $srm_path,
    supported_vos      => $supported_vos,
    user_white_list    => $user_white_list,
  }

  # needs voname,vo_sw_dir and vo_default_se
  $defaults = {
    'vo_default_se' => $default_se,
  }

  create_resources('vosupport::voenv', $vo_environments, $defaults)
  class { 'vosupport::vo_environment':
    voenvdefaults => $vo_environments,
  }

  file { '/usr/etc/globus-user-env.sh': ensure => present, }

  file { 'grid-env-funcs.sh':
    path   => '/usr/libexec/grid-env-funcs.sh',
    source => 'puppet:///modules/vosupport/grid-env-funcs.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { 'clean-grid-env-funcs.sh':
    path   => '/usr/libexec/clean-grid-env-funcs.sh',
    source => 'puppet:///modules/vosupport/clean-grid-env-funcs.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
}
