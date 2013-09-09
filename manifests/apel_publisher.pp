class site::apel_publisher (
  $site_name                 = 'UKI-SOUTHGRID-XXX-HEP',
  $mysql_root_password       = 'changeme',
  $mysql_backup_folder       = '/tmp/mysql_backup',
  $mysql_apel_password       = 'pleasechangeme',
  $list_of_apel_parser_hosts = [
    ],) inherits site::params {
  yumhelper::modify { 'enable-epel':
    repository => 'epel',
    enable     => true,
  }

  yumhelper::modify { 'disable-epel':
    repository => 'epel',
    enable     => false,
  }

  class { 'apelpublisher::repositories':
  }

  class { 'apelpublisher::install':
    mysql_root_password => $mysql_root_password,
    mysql_backup_folder => $mysql_backup_folder,
    mysql_apel_password => $mysql_apel_password,
  }

  class { 'apelpublisher::create_database':
    mysql_root_password       => $mysql_root_password,
    mysql_apel_password       => $mysql_apel_password,
    list_of_apel_parser_hosts => $list_of_apel_parser_hosts,
  }

  class { 'apelpublisher::config':
    mysql_password => $mysql_apel_password,
    site_name      => $site_name,
  }

  class { 'apelpublisher::cron':
    cron_hours => 2,
    cron_minutes => 42,
  }

  Class['apelpublisher::repositories'] -> Class['apelpublisher::install'] -> Class['apelpublisher::create_database'] -> 
  Class['apelpublisher::config'] -> Class['apelpublisher::cron']

  Yumhelper::Modify['enable-epel'] -> Class['apelpublisher::install'] -> Yumhelper::Modify['disable-epel']
}