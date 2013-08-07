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

  file { $backup_directories: ensure => "directory", }

  # cron job for dumping the PostgreSQL database
  cron { postgresql_backup:
    command => "/usr/bin/sudo -u foreman /usr/bin/pg_dump &> ${backup_folder}/foreman/pg_dump.txt",
    user    => root,
    hour    => '*/8',
  }
}