#
class site::dmlite_hdfs_headnode (
  $mysql_root_pass  = 'PASS',
  $mysql_dpm_pass   = 'MYSQLPASS',
  $mysql_dpm_user   = 'dpmmgr',
  $gateways         = ['dpmhdfs01.example.com', 'dpmhdfs02.example.com'],
  $token_password   = 'TOKEN_PASSWORD',
  $localdomain      = 'phy.bris.ac.uk',
  $volist           = ['atlas', 'cms', 'dteam', 'ops', 'lhcb', 'alice'],
#  $disk_nodes       = "${::fqdn}",
  $xrootd_sharedkey = 'A32TO64CHARACTERKEYTESTTESTTESTTEST',
  $debug            = false,
  $local_db         = true) {
  #
  $db_user      = $mysql_dpm_user
  $db_pass      = $mysql_dpm_pass
  $disk_nodes   = join($gateways, ' ')
  # use $gateways to get
  # remote_nodes => "dpmhdfs01.example.com:2811,dpmhdfs02.example.com:2811",
  # first append :2811 to each gateway
  $remotes      = suffix($gateways, ':2811')
  $remote_nodes = join($remotes, ',')

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

  #  Class[Dmlite::Head] -> Class[Dmlite::Plugins::Adapter::Install]
  #  Class[Lcgdm::Dpm::Service] -> Class[Dmlite::Plugins::Adapter::Install]
  #  Class[Lcgdm::Ns::Config] -> Class[Dmlite::Srm::Service]
  #  Class[Dmlite::Plugins::Adapter::Install] ~> Class[Dmlite::Srm]
  #  Class[Dmlite::Plugins::Adapter::Install] ~> Class[Dmlite::Gridftp]
  #  Class[Dmlite::Plugins::Adapter::Install] -> Class[Dmlite::Dav]
  #  Dmlite::Plugins::Adapter::Create_config <| |> ->
  #  Class[Dmlite::Dav::Install]

  Class[Bdii::Install] -> Class[Lcgdm::Bdii::Dpm]
  Class[Lcgdm::Bdii::Dpm] -> Class[Bdii::Service]
  Class[fetchcrl::service] -> Class[Xrootd::Config]

  #
  # The firewall configuration
  #
  firewall { '050 allow http and https':
    proto  => 'tcp',
    dport  => [80, 443],
    action => 'accept'
  }

  firewall { '050 allow rfio':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '5001',
    action => 'accept'
  }

  firewall { '050 allow rfio range':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '20000-25000',
    action => 'accept'
  }

  firewall { '050 allow gridftp control':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '2811',
    action => 'accept'
  }

  firewall { '050 allow gridftp range':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '20000-25000',
    action => 'accept'
  }

  firewall { '050 allow srmv2.2':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '8446',
    action => 'accept'
  }

  firewall { '050 allow xrootd':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '1095',
    action => 'accept'
  }

  firewall { '050 allow cmsd':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '1094',
    action => 'accept'
  }

  firewall { '050 allow DPNS':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '5010',
    action => 'accept'
  }

  firewall { '050 allow DPM':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '5015',
    action => 'accept'
  }

  firewall { '050 allow bdii':
    state  => 'NEW',
    proto  => 'tcp',
    dport  => '2170',
    action => 'accept'
  }

  firewall { "050 allow mysql":
    state  => "NEW",
    proto  => "tcp",
    dport  => "3306",
    action => "accept"
  }

  firewall { "050 allow xrootd atlas":
    state  => "NEW",
    proto  => "tcp",
    dport  => "11000",
    action => "accept"
  }

  firewall { "050 allow xrootd cms":
    state  => "NEW",
    proto  => "tcp",
    dport  => "11001",
    action => "accept"
  }

  #
  # MySQL server setup - disable if it is not local
  #
  if ($local_db) {
    Class[Mysql::Server] -> Class[Lcgdm::Ns::Service]

    # adding perf tunings
    $override_options = {
      'mysqld' => {
        'max_connections'         => '1000',
        'query_cache_size'        => '256M',
        'query_cache_limit'       => '1MB',
        'innodb_flush_method'     => 'O_DIRECT',
        'innodb_buffer_pool_size' => '1000000000',
        'bind-address'            => "${::ipaddress}",
      }
    }

    class { 'mysql::server':
      service_enabled  => true,
      root_password    => "${mysql_root_pass}",
      override_options => $override_options
    }
  }

  # grant access to DMLite gateways
  site::dmlite::grant_mysql_access { $gateways:
    db_user => $db_user,
    db_pass => $db_pass,
   }
#  $gma_defaults = {
#    'db_user' => $mysql_dpm_user,
#    'db_pass' => $mysql_dpm_pass
#  }
#
#  create_resources(site::dmlite::grant_mysql_access, $gateways, $gma_defaults)

  #
  # DPM and DPNS daemon configuration.
  #
  class { 'lcgdm':
    dbflavor => 'mysql',
    dbuser   => "${db_user}",
    dbpass   => "${db_pass}",
    dbhost   => 'localhost',
    domain   => "${localdomain}",
    volist   => $volist,
  }

  #
  # RFIO configuration.
  #
  class { 'lcgdm::rfio':
    dpmhost => "${::fqdn}",
  }

  #
  # You can define your pools here (example is commented).
  #
  Class[Lcgdm::Dpm::Service] -> Lcgdm::Dpm::Pool <| |>

  # lcgdm::dpm::pool { 'mypool': def_filesize => '100M' }
  #
  #
  # You can define your filesystems here (example is commented).
  #
  #  Class[Lcgdm::Base::Config] ->
  #  file {
  #    '/srv/dpm':
  #      ensure => directory,
  #      owner  => 'dpmmgr',
  #      group  => 'dpmmgr',
  #      mode   => '0775';
  #
  #    '/srv/dpm/01':
  #      ensure  => directory,
  #      owner   => 'dpmmgr',
  #      group   => 'dpmmgr',
  #      seltype => 'httpd_sys_content_t',
  #      mode    => '0775';
  #  } ->
  #  lcgdm::dpm::filesystem { "${::fqdn}-myfsname":
  #    pool   => 'mypool',
  #    server => "${::fqdn}",
  #    fs     => '/srv/dpm'
  #  }

  #
  # Entries in the shift.conf file, you can add in 'host' below the list of
  # machines that the DPM should trust (if any).
  #
  lcgdm::shift::trust_value {
    'DPM TRUST':
      component => 'DPM',
      host      => "${disk_nodes}";

    'DPNS TRUST':
      component => 'DPNS',
      host      => "${disk_nodes}";

    'RFIO TRUST':
      component => 'RFIOD',
      host      => "${disk_nodes}",
      all       => true
  }

  lcgdm::shift::protocol { 'PROTOCOLS':
    component => 'DPM',
    proto     => 'rfio gsiftp http https xroot'
  }

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

  $cmd    = '/usr/sbin/edg-mkgridmap'
  $conf   = '/etc/lcgdm-mkgridmap.conf'
  $output = '/etc/lcgdm-mapfile'

  exec { "${cmd} --conf=${conf} --safe --output=${output}":
    require   => File['/etc/lcgdm-mkgridmap.conf'],
    subscribe => File['/etc/lcgdm-mkgridmap.conf'],
  }

  #
  # dmlite configuration.
  #
  class { 'dmlite::head_hdfs':
    token_password  => $token_password,
    mysql_username  => $db_user,
    mysql_password  => $db_pass,
    hdfs_namenode   => 'jt-37-00.dice.priv',
    hdfs_port       => 8020,
    hdfs_user       => 'dpmmgr',
    enable_io       => true,
    hdfs_tmp_folder => '/tmp',
    hdfs_gateway    => join($gateways, ','),
    hdfs_replication=> 2,
  }

  #
  # Frontends based on dmlite.
  #
  class { 'dmlite::dav::install':
  }

  class { 'dmlite::dav::config':
    enable_hdfs => true
  }

  class { 'dmlite::dav::service':
  }

  class { 'dmlite::gridftp':
    dpmhost      => "${::fqdn}",
    remote_nodes => $remote_nodes,
    enable_hdfs  => true,
    log_level    => 'INFO',
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

  $atlas_fed = {
    name           => 'fedredir_atlas',
    fed_host       => 'atlas-xrd-uk.cern.ch',
    xrootd_port    => 1094,
    cmsd_port      => 1098,
    local_port     => 11000,
    namelib_prefix => "/dpm/${localdomain}/home/atlas",
    namelib        => "XrdOucName2NameLFC.so pssorigin=localhost sitename=UKI-SOUTHGRID-BRIS-HEP",
    paths          => [ '/atlas' ]
  }

  $cms_fed = {
    name           => 'fedredir_cms',
    fed_host       => 'xrootd-cms.infn.it',
    xrootd_port    => 1094,
    cmsd_port      => 1213,
    local_port     => 11001,
    namelib_prefix => "/dpm/${localdomain}/home/cms",
    namelib        => "libXrdCmsTfc.so file:/etc/xrootd/storage.xml?protocol=direct",
    paths          => [ '/store' ]
  }

  class { 'dmlite::xrootd':
    nodetype             => ['head'],
    domain               => "${localdomain}",
    dpm_xrootd_debug     => $debug,
    dpm_xrootd_sharedkey => "${xrootd_sharedkey}",
    enable_hdfs          => true,
    xrd_report           => "xrootd.t2.ucsd.edu:9931,atl-prod05.slac.stanford.edu:9931 every 60s all sync",
    xrootd_monitor       => "all flush 30s ident 5m fstat 60 lfn ops ssq xfr 5 window 5s dest fstat info user redir CMS-AAA-EU-COLLECTOR.cern.ch:9330 dest fstat info user redir atlas-fax-eu-collector.cern.ch:9330",
    dpm_xrootd_fedredirs => { "atlas" => $atlas_fed, "cms" => $cms_fed },
  }

  # BDII
  include('bdii')

  # DPM GIP config
  class { 'lcgdm::bdii::dpm':
    sitename => 'UKI-SOUTHGRID-BRIS-HEP',
    vos      => $volist,
    hdfs     => true,
  }
  # make sure user ldap is created
  User <| title == ldap |>

  # memcache configuration
  Class[Dmlite::Plugins::Memcache::Install] ~> Class[Dmlite::Dav::Service]
  Class[Dmlite::Plugins::Memcache::Install] ~> Class[Dmlite::Gridftp]
  Class[Dmlite::Plugins::Memcache::Install] ~> Class[Xrootd::Service]

  Class[Lcgdm::Base::Config] ->
  class { 'memcached':
    max_memory => 2000,
    listen_ip  => '127.0.0.1',
  } ->
  class { 'dmlite::plugins::memcache':
    expiration_limit => 600,
    posix            => 'on',
  }

  # class {'dmlite::plugins::hdfs':}

  #
  # dmlite shell configuration.
  #
  class { 'dmlite::shell':
  } ->
  exec { "configurepool":
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    environment => ['LD_LIBRARY_PATH=/usr/lib/jvm/java/jre/lib/amd64/server/'],
    command     => "dmlite-shell -e 'pooladd  hdfs_pool hdfs';dmlite-shell -e 'poolmodify hdfs_pool hostname jt-37-00.dice.priv'; dmlite-shell -e 'poolmodify hdfs_pool username dpmmgr'; dmlite-shell -e 'poolmodify hdfs_pool mode rw'",
    unless      => "dmlite-shell -e 'poolinfo rw",
    require     => Package['dmlite-shell'],
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
