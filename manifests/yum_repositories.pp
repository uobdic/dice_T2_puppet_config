class site::yum_repositories ($repositories = $site::params::repositories) inherits site::params {
  $defaults = {
    'enabled'  => 1,
    'gpgcheck' => 1,
  }
  create_resources('yumrepo', $repositories, $defaults)
}
