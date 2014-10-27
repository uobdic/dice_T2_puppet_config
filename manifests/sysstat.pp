class site::sysstat () {
package {'sysstat' : ensure => installed }
cron {sysstat :
      command => '/usr/lib64/sa/sa1 1 1',
      minute => '*/10',
      }
cron {sysstatsummary :
      command => '/usr/lib64/sa/sa2 -A',
      minute => 53,
      hour => 23,
      }
}
