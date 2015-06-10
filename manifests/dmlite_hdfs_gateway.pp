# This is the GridFTP server equivalent for DMLite that does all the heavy
# lifting
class site::dmlite_hdfs_gateway (
  $headnode_fqdn    = 'dpmhdfs-head.example.com',
  $mysql_dpm_pass   = 'MYSQLPASS',
  $mysql_dpm_user   = 'dpmmgr',
  $gateways         = ['dpmhdfs01.example.com', 'dpmhdfs02.example.com'],
  $token_password   = 'TOKEN_PASSWORD',
  $localdomain      = 'phy.bris.ac.uk',
  $volist           = ['atlas', 'cms', 'dteam', 'ops', 'lhcb', 'alice'],
  $xrootd_sharedkey = 'A32TO64CHARACTERKEYTESTTESTTESTTEST',
  $debug            = false,) {
  $db_user = $mysql_dpm_user
  $db_pass = $mysql_dpm_pass

  #
  # Set inter-module dependencies
  #
  Class[Dmlite::Plugins::Hdfs::Install] -> Class[Dmlite::Gridftp]
  Class[Dmlite::Plugins::Hdfs::Install] -> Class[Dmlite::Dav::Config]
  Class[Dmlite::Plugins::Hdfs::Install] -> Class[Xrootd::Config]
  Class[Dmlite::Plugins::Mysql::Install] -> Class[Dmlite::Gridftp]
  Class[Dmlite::Plugins::Mysql::Install] -> Class[Dmlite::Dav::Config]
  Class[Dmlite::Plugins::Mysql::Install] -> Class[Xrootd::Config]

  Class[Dmlite::Plugins::Hdfs::Config] -> Class[Dmlite::Dav::Config]
  Class[Dmlite::Plugins::Hdfs::Config] -> Class[Dmlite::Gridftp]
  Class[Dmlite::Plugins::Hdfs::Config] -> Class[Dmlite::Xrootd]

  Class[fetchcrl::service] -> Class[Xrootd::Config]

  #
  # The firewall configuration
  #
  firewall { '950 allow http and https':
    proto  => 'tcp',
    dport  => [80, 443],
    action => 'accept'
  }

  firewall { '950 allow rfio':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '5001',
    action => 'accept'
  }

  firewall { '950 allow rfio range':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '20000-25000',
    action => 'accept'
  }

  firewall { '950 allow gridftp control':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '2811',
    action => 'accept'
  }

  firewall { '950 allow gridftp range':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '20000-25000',
    action => 'accept'
  }

  firewall { '950 allow xrootd':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '1095',
    action => 'accept'
  }

  firewall { '950 allow cmsd':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '1094',
    action => 'accept'
  }

  firewall { '950 allow DPNS':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '5010',
    action => 'accept'
  }

  firewall { '950 allow DPM':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '5015',
    action => 'accept'
  }

  # lcgdm configuration.
  #
  class { 'lcgdm::base::config':
  }

  class { 'lcgdm::base::install':
  }

  class { 'lcgdm::ns::client':
    flavor  => 'dpns',
    dpmhost => "${headnode_fqdn}"
  }

  #
  # VOMS configuration (same VOs as above).
  #
  # ['atlas', 'cms', 'dteam', 'ops', 'lhcb', 'alice']
  class { 'voms::atlas':
  }

  class { 'voms::alice':
  }

  class { 'voms::cms':
  }

  class { 'voms::dteam':
  }

  class { 'voms::lhcb':
  }

  class { 'voms::ops':
  }

  #
  # Gridmapfile configuration.
  #
  $groupmap = {
    'vomss://voms2.cern.ch:8443/voms/atlas?/atlas'      => 'atlas',
    'vomss://lcg-voms2.cern.ch:8443/voms/atlas?/atlas'  => 'atlas',
    'vomss://voms2.cern.ch:8443/voms/cms?/cms'          => 'cms',
    'vomss://lcg-voms2.cern.ch:8443/voms/cms?/cms'      => 'cms',
    'vomss://voms2.cern.ch:8443/voms/lhcb?/lhcb'        => 'lhcb',
    'vomss://lcg-voms2.cern.ch:8443/voms/lhcb?/lhcb'    => 'lhcb',
    'vomss://voms2.cern.ch:8443/voms/alice?/alice'      => 'alice',
    'vomss://lcg-voms2.cern.ch:8443/voms/alice?/alice'  => 'alice',
    'vomss://voms2.cern.ch:8443/voms/ops?/ops'          => 'ops',
    'vomss://lcg-voms2.cern.ch:8443/voms/ops?/ops'      => 'ops',
    'vomss://voms.hellasgrid.gr:8443/voms/dteam?/dteam' => 'dteam'
  }

  lcgdm::mkgridmap::file { 'lcgdm-mkgridmap':
    configfile   => '/etc/lcgdm-mkgridmap.conf',
    mapfile      => '/etc/lcgdm-mapfile',
    localmapfile => '/etc/lcgdm-mapfile-local',
    logfile      => '/var/log/lcgdm-mkgridmap.log',
    groupmap     => $groupmap,
    localmap     => {
      'nobody' => 'nogroup'
    }
    ,
  }

  #
  # dmlite configuration.
  #


  class { 'dmlite::disk_hdfs':
    token_password  => "${token_password}",
    mysql_username  => "${db_user}",
    mysql_password  => "${db_pass}",
    mysql_host      => "${headnode_fqdn}",
    hdfs_namenode   => 'jt-37-00.dice.priv',
    hdfs_port       => 8020,
    hdfs_user       => 'dpmmgr',
    enable_io       => true,
    hdfs_tmp_folder => '/data/dpm/tmp',
  }

  #
  # Frontends based on dmlite.
  #
  class { 'dmlite::dav::install':
  }

  class { 'dmlite::dav::config':
    enable_hdfs    => true,
    dav_http_port  => 11180,
    dav_https_port => 11443,
  }

  class { 'dmlite::dav::service':
  }

  # dpmhost is not used for HDFS, but needs to be defined for the class
  # (even with bogus value)
  class { 'dmlite::gridftp':
    dpmhost     => "${headnode_fqdn}",
    enable_hdfs => true,
    data_node   => 1,
    log_level   => 'ERROR',
  #   log_level => 'ERROR,WARN,INFO,TRANSFER,DUMP,ALL',
  }

  # The XrootD configuration is a bit more complicated and
  # the full config (incl. federations) will be explained here:
  # https://svnweb.cern.ch/trac/lcgdm/wiki/Dpm/Xroot/PuppetSetup

  #
  # The simplest xrootd configuration.
  #
  class { 'xrootd::config':
    xrootd_user  => 'dpmmgr',
    xrootd_group => 'dpmmgr'
  }

  class { 'dmlite::xrootd':
    nodetype             => ['disk'],
    domain               => "${localdomain}",
    dpm_xrootd_debug     => $debug,
    dpm_xrootd_sharedkey => "${xrootd_sharedkey}",
    enable_hdfs          => true,
  }

  # limit conf

  $limits_config = {
    '*' => {
      nofile => {
        soft => 65000,
        hard => 65000
      }
      ,
      nproc  => {
        soft => 65000,
        hard => 65000
      }
      ,
    }
  }

  class { 'limits':
    config    => $limits_config,
    use_hiera => false
  }
}
