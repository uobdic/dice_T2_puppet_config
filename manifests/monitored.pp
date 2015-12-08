#
# Class needed for monitoring. Sets custom fact monitoring_server
#
class site::monitored ($monitored_by) {
  $fact_name = 'monitoring_server'
  $fact_value = $monitored_by

  file { ['/etc/facter', '/etc/facter/facts.d']: ensure => directory, } ->
  file { "/etc/facter/facts.d/${fact_name}":
    ensure  => present,
    content => template("${module_name}/custom_fact.py.erb"),
    mode    => 'a+x',
  }
}
