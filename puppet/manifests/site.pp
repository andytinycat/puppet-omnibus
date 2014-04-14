node "ubuntu12" {

   package { [
        "unzip",
        "build-essential",
   ] :
     ensure => installed
   }

   include rbenv
   rbenv::install_ruby { "1.9.3-p545": 
       require => Package["unzip"]
   }

}

node "centos6" {

   include rbenv
   rbenv::install_ruby { "1.9.3-p545": 
       require => Package["unzip"]
   }

}
