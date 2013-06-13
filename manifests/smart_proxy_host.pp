class site::smart_proxy_host inherits site::params {
  account { 'foreman-proxy':
    home_dir => '/usr/share/foreman-proxy',
    groups   => ['puppet'],
    comment  => 'Foreman Proxy deamon user',
    password => '!!',
    shell    => '/sbin/nologin',
  }
}