class site::params {
  $cluster = hiera('cluster_name', 'DICE')
  # CVMFS specific parameters for the site
  $cvmfs_version = hiera('cvmfs_version', present) # or latest if you have faith
  $cvmfs_quota_limit = hiera('cvmfs_quota_limit', 20000)
  $cvmfs_http_proxy = hiera('cvmfs_http_proxy', 'http://squid.example.org:3128')
  $cvmfs_server_url = hiera('cvmfs_server_url', 'http://web.example.org:80/opt/example')
  $cvmfs_cache_base = hiera('cvmfs_cache_base', '/var/cache/cvmfs2')
  $user_accounts = undef
  $user_groups = undef

  $major_release = regsubst($::operatingsystemrelease, '^(\d+)\.\d+$', '\1')
  $repositories = {
    'epel' => {
      descr       => "Extra Packages for Enterprise Linux 6${$major_release}",
      mirrorlist  => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=x86_64',
      gpgcheck    => 1,
      gpgkey      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM',
      enabled     => 0,
      includepkgs => 'cvmfs,cvmfs-keys',
      priority    => 80,
      require     => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM'],
    }
  }
  
  
  # this will have to move
  $basic_packages = hiera_array('basic_packages', ['nano', 'yum', 'git', 'wget', 'man']) 

  $syslog = $major_release ? {
    '5'     => 'syslog',
    '6'     => 'rsyslog',
    default => 'syslog',
  } }
