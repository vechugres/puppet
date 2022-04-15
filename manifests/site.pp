node 'slave1' {
  include static
  file {'/root/README':
    ensure => absent
    }
}

node 'slave2' {
  include dynamic
  file {'/root/README':
    ensure => absent
    }
}

node 'master.puppet' {
include nginx
nginx::resource::server { 'static':
  listen_port => 80,
  proxy => 'http://192.168.50.10:80',
  }
  
nginx::resource::server { 'dynamic':
  listen_port => 81,
  proxy => 'http://192.168.50.15:80',
  }
  
}

class dynamic{
  package{['httpd', 'php']:
    ensure => installed
  }
  file {'/var/www/html':
    ensure => directory
  }
  file {'/var/www/html/index.php':
    ensure => file,
    source => 'puppet:///modules/dynamic/index.php'
  }
  file{'/etc/httpd/conf.d/dynamic.conf':
    ensure => file,
    source => 'puppet:///modules/dynamic/dynamic.conf',
    notify => Service['httpd']
  }
  service{'httpd':
    ensure => running
  }
}

class static{
  package{['httpd', 'php']:
    ensure => installed
  }
  file {'/var/www/html':
    ensure => directory
  }
  file {'/var/www/html/index.php':
    ensure => file,
    source => 'puppet:///modules/dynamic/index.php'
  }
  file{'/etc/httpd/conf.d/static.conf':
    ensure => file,
    source => 'puppet:///modules/dynamic/static.conf',
    notify => Service['httpd']
  }
  service{'httpd':
    ensure => running
  }
}
