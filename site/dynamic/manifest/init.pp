class dynamic{
  package{['httpd', 'php']:
    ensure => installed
  }
  file {'/var/www/php':
    ensure => directory
  }
  file {'/var/www/php/index.php':
    ensure => file,
    source => 'puppet:///modules/dynamic/index.php'
  }
  file{'/etc/httpd/conf.d/demo.conf':
    ensure => file,
    source => 'puppet:///modules/dynamic/demod.conf',
    notify => Service['httpd']
  }
  service{'httpd':
    ensure => running
  }
}
