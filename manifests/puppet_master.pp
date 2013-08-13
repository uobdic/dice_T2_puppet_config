# Class: site::puppetmaster
#
# This module manages the Puppet master
#
# Parameters: backup_folder
class site::puppet_master (
  $backup_folder = '/backup') {
  # create backup folders
  $backup_directories = [
    $backup_folder,
    "${backup_folder}/foreman/",
    "${backup_folder}/puppet/",
    "${backup_folder}/root/"]

  file { $backup_directories: ensure => 'directory', }

  # cron job for dumping the PostgreSQL database
  cron { postgresql_backup:
    command => "/usr/bin/pg_dump &> ${backup_folder}/foreman/pg_dump_`date +\\%d_\\%m_\\%Y_\\%H.\\%M`.txt",
    user    => foreman,
    hour    => '*/8',
  }

  $keep_for_n_days = 3

  cron { postgresql_backup_cleanup:
    command => "find ${backup_folder}/foreman/pg_dump* -mtime +3 -exec rm {} \\;",
    user    => root,
    hour    => '*/8',
  }
}
