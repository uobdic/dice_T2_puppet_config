# == Define: Pool_Account
#  A defined type for managing grid pool accounts
#
# === Examples
#
#  pool_account { 'cmspil111':
#    home_dir      => '/home/cmspil111',
#    uuid          => 80111,
#    primary_group => 'cmspilot',
#    groups        => [ 'cms'],
#  }
define pool_account (
  $username      = $title,
  $password      = '*NP*',
  $shell         = '/bin/bash',
  $manage_home   = true,
  $home_dir      = "/home/${title}",
  $primary_group = undef,
  $uid           = undef,
  $groups        = [
    ],
  $ensure        = present,
  $comment       = "$title Puppet-managed User") {
  case $ensure {
    present : {
      $dir_ensure = directory
      $dir_owner  = $username
      $dir_group  = $primary_group
      User[$title] -> File["${title}_home"] 
    }
    absent  : {
      $dir_ensure = absent
      $dir_owner  = undef
      $dir_group  = undef
      File["${title}_home"] -> User[$title]
    }
    default : {
      err("Invalid value given for ensure: ${ensure}. Must be one of present,absent.")
    }
  }
  
  user {
    $title:
      ensure     => $ensure,
      name       => $username,
      comment    => $comment,
      uid        => $uid,
      password   => $password,
      shell      => $shell,
      gid        => $primary_group,
      groups     => $groups,
      home       => $home_dir,
      managehome => $manage_home,
  }

  file {
    "${title}_home":
      ensure  => $dir_ensure,
      path    => $home_dir,
      owner   => $dir_owner,
      group   => $dir_group,
      mode    => 0750;
  }

}