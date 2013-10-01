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
  $user_white_list    = ' ',) {
  yumhelper::modify { 'enable-epel-for-glexecwn':
    repository => 'epel',
    enable     => true,
  }

  yumhelper::modify { 'disable-epel-for-glexecwn':
    repository => 'epel',
    enable     => false,
  }

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

  Yumhelper::Modify['enable-epel-for-glexecwn'] -> Class['glexecwn'] ->
  Yumhelper::Modify['disable-epel-for-glexecwn']

}