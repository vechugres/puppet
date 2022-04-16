node 'slave1.puppet' {

 include selinux
 
 package { 'httpd':
  ensure => latest,
 }

 file {'/var/www/html/index.html':
  ensure => file,
  source => 'puppet:///modules/static/index.html',
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
  source => 'puppet:///modules/dynamic/index.php',
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

node 'minecraft.puppet' {

include selinux

 package {'java-17-openjdk':
  ensure => installed,
}

 file {'/opt/minecraft':
  ensure => directory,
}

 file {'/opt/minecraft/eula.txt':
  content => 'eula=true',
}

 wget::fetch { "minecraft-server":
     source      => 'https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar',
     destination => '/opt/minecraft/',
     timeout     => 0,
      verbose     => false,
}

 file {'/etc/systemd/system/minecraft-server.service':
     ensure => file,
     source => 'puppet:///modules/minecraft-server/',
}
 ~> service { 'minecraft-server':
     ensure => running,
     enable => true,
   }
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
