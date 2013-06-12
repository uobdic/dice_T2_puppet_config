class site::params {
  $cluster = "DICE"
  #CVMFS specific parameters for the site
  $cvmfs_version  = present #or latest if you have faith
  $cvmfs_quota_limit = 20000
  $cvmfs_http_proxy = 'http://squid.example.org:3128'
  $cvmfs_server_url = 'http://web.example.org:80/opt/example'
  $cvmfs_cache_base = '/var/cache/cvmfs2'
  $user_accounts = undef
  $user_groups = undef
}