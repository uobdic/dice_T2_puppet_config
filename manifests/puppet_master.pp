# Class: site::puppetmaster
#
# This module manages the Puppet master
#
# Parameters: backup_folder
class site::puppet_master (
  $backup_folder = '/backup') {
  # create backup folders
  file { "${backup_folder}/foreman/":
    ensure => 'directory',
    owner  => 'foreman',
  }

  file { [
    "${backup_folder}/puppet/",
    "${backup_folder}/root/"]:
    ensure => 'directory',
    owner  => 'root',
  }

  $keep_for_n_days = 3

  # cron job for dumping the PostgreSQL database
  cron { postgresql_backup:
    command => "pg_dump | gzip &> ${backup_folder}/foreman/pg_dump_`date +\\%d_\\%m_\\%Y_\\%H.\\%M`.gz",
    user    => foreman,
    hour    => '*/8',
    minute  => 0,
    environment => ['/usr/bin', '/bin'],
  }

  cron { postgresql_backup_cleanup:
    command => "find ${backup_folder}/foreman/pg_dump* -mtime +3 -exec rm {} \\;",
    user    => root,
    hour    => '*/8',
    minute  => 0,
    environment => ['/bin'],
  }

  cron { puppet_backup:
    command => "tar czf ${backup_folder}/puppet/puppet_`date +\\%d_\\%m_\\%Y_\\%H.\\%M`.tar.gz /etc/puppet ",
    user    => root,
    hour    => '*/8',
    minute  => 0,
    environment => ['/bin'],
  }

  cron { puppet_backup_cleanup:
    command => "find ${backup_folder}/puppet/puppet_* -mtime +3 -exec rm {} \\;",
    user    => root,
    hour    => '*/8',
    minute  => 0,
    environment => ['/bin'],
  }
}
