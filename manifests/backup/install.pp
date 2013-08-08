class site::backup::install {
  package { [
    'lgtoman',
    'lgtoclnt']: ensure => present, }
}
