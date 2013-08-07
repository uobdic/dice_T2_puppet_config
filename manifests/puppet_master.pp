# Class: site::puppetmaster
#
# This module manages the Puppet master
#
# Parameters: backup_folder
class site::puppetmaster (
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
    command => "/usr/bin/pg_dump &> ${backup_folder}/foreman/pg_dump.txt",
    user    => foreman,
    hour    => '*/8',
  }
}