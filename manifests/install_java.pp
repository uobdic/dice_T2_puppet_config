class site::install_java (
  $version = site::params::java_version, 
  $from_repository = $site::params::java_repository
) inherits site::params {
  if ($version) {
    package { 'jdk':
      ensure  => $version,
      require => Yumrepo[$from_repository],
    }
  }
}