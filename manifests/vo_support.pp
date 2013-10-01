class site::vo_support (
  $supported_vos = [],) {
  class { 'vosupport':
    supported_vos                => $supported_vos,
    enable_environment           => true,
    enable_gridmapdir_for_group  => undef,
    enable_mappings_for_service  => undef,
    enable_mkgridmap_for_service => undef,
    enable_poolaccounts          => false,
    enable_voms                  => false,
  }
}
