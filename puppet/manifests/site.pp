node "ubuntu12" {

    exec { "apt-update":
        command => "/usr/bin/apt-get update"
    }

    Exec["apt-update"] -> Package <| |>

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
    rbenv::install_ruby { "1.9.3-p545": }

}
