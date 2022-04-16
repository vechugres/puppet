node 'slave1.puppet' {

 include selinux
 
 package { 'httpd':
  ensure => latest,
 }

 file {'/var/www/html/index.html':
  ensure => file,
  source => 'puppet:///modules/static/index.html'
 }
 
file {'/etc/httpd/conf.d/static.conf':
  ensure => file,
  source => 'puppet:///modules/static/static.conf',
 }

 service { 'httpd':
  ensure => running,
  enable => true,
 }

 service { 'firewalld':
  ensure => stopped,
  enable => false,
 }

 file {'/root/README':
  ensure => absent,
 }
}

node 'slave2.puppet' {

 include selinux

 package { ['httpd','php'] :
  ensure => latest,
 }

 file {'/var/www/html/index.php':
  ensure => file,
  source => 'puppet:///modules/dynamic/index.php'
 }
 
file {'/etc/httpd/conf.d/dynamic.conf':
  ensure => file,
  source => 'puppet:///modules/dynamic/dynamic.conf',
 }
 
 service { 'httpd':
  ensure => running,
  enable => true,
 }
 
 service { 'firewalld':
  ensure => stopped,
  enable => false,
 }
 
 file {'/root/README':
  ensure => absent,
 }
}

node 'master.puppet' {

include nginx

nginx::resource::server { 'static':
  listen_port => 8080,
  proxy => 'http://192.168.55.10:80',
  }
  
nginx::resource::server { 'dynamic':
  listen_port => 8081,
  proxy => 'http://192.168.55.15:80',
  }
  
}

class { selinux:
  mode => 'disabled',
  type => 'targeted',
}
