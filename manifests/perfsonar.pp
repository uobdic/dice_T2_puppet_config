# perfsonar setup
class site::perfsonar (
  $admin_email = 'admin1@site.edu',
  $type        = 'latency') {
  # attach this to motd:
  #
  # To start configuration, run:
  #
  # sudo /opt/perfsonar_ps/toolkit/scripts/nptoolkit-configure.py
  #
  # Once you set passwords, you can login to the web interface and finish
  # configuration. The web interface should be available at:
  #
  # https://$fqdn/toolkit
  #

  # firewall rules
  class { 'site::firewall::perfsonar':
    type => $type,
  }

  # mesh configuration
  # /opt/perfsonar_ps/mesh_config/etc/agent_configuration.conf
  file { '/opt/perfsonar_ps/mesh_config/etc/agent_configuration.conf':
    ensure  => present,
    content => template('site/agent_configuration.conf.erb'),
    owner   => perfsonar,
    group   => perfsonar,
  }
}
