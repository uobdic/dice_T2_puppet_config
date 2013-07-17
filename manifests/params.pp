class site::params ($test_message = undef) {
  $cluster = "DICE"
  # CVMFS specific parameters for the site
  $cvmfs_version = present # or latest if you have faith
  $cvmfs_quota_limit = 20000
  $cvmfs_http_proxy = 'http://squid.example.org:3128'
  $cvmfs_server_url = 'http://web.example.org:80/opt/example'
  $cvmfs_cache_base = '/var/cache/cvmfs2'
  $user_accounts = undef
  $user_groups = undef

  $major_release = regsubst($::operatingsystemrelease, '^(\d+)\.\d+$', '\1')
  $repositories = {
    'epel'      => {
      descr       => "Extra Packages for Enterprise Linux 6${$major_release}",
      mirrorlist  => "https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=x86_64",
      gpgcheck    => 1,
      gpgkey      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM',
      enabled     => 0,
      includepkgs => 'cvmfs,cvmfs-keys',
      priority    => 80,
      require     => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM']
    }
  }
  
  $for_testing = "default"
  if $test_message != undef {
    $for_testing = $test_message
  }
  
  $java_repository = 'bristol'
  $java_version = '1.6.0_43-fcs'
  
  $basic_packages = {
    "nano" => {},
    "yum" => {},
    "git" => {},
    "wget" => {},
    "mlocate" => {},
    "man" => {},
  }
}