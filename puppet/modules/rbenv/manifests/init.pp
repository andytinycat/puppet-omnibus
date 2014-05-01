class rbenv {

    $rbenv_version         = "0.4.0"
    $ruby_build_version    = "20140225"
    $rbenv_bundler_version = "0.97"

    $install_base          = "/opt/rbenv"

    # Fetch specific versions of these tools from github.

    exec { "fetch-rbenv":
        command => "/usr/bin/wget -c -q https://github.com/sstephenson/rbenv/archive/v${rbenv_version}.zip -O /var/tmp/rbenv.zip",
        creates => "/var/tmp/rbenv.zip",
    }

    exec { "fetch-ruby-build":
        command => "/usr/bin/wget -c -q https://github.com/sstephenson/ruby-build/archive/v${ruby_build_version}.zip -O /var/tmp/ruby-build.zip",
        creates => "/var/tmp/ruby-build.zip",
    }

    exec { "fetch-rbenv_bundler":
        command => "/usr/bin/wget -c -q https://github.com/carsomyr/rbenv-bundler/archive/${rbenv_bundler_version}.zip -O /var/tmp/rbenv-bundler.zip",
        creates => "/var/tmp/rbenv-bundler.zip",
    }

    exec { "fetch-rbenv-sudo":
        command => "/usr/bin/wget -c -q https://github.com/dcarley/rbenv-sudo/archive/master.zip -O /var/tmp/rbenv-sudo.zip",
        creates => "/var/tmp/rbenv-sudo.zip",
    }

    # Install rbenv:

    exec { "unzip-rbenv":
        command => "/usr/bin/unzip /var/tmp/rbenv.zip -d ${install_base}",
        creates => "${install_base}/rbenv-${rbenv_version}",
        require => Exec["fetch-rbenv"],
    }

    file { "${install_base}/rbenv-${rbenv_version}/plugins":
        ensure => directory,
        require => Exec["unzip-rbenv"]
    }



    # Install ruby-build

    exec { "unzip-ruby-build":
        require => File["${install_base}/rbenv-${rbenv_version}/plugins"],
        command => "/usr/bin/unzip /var/tmp/ruby-build.zip -d ${install_base}/rbenv-${rbenv_version}/plugins/",
        creates => "${install_base}/rbenv-${rbenv_version}/plugins/ruby-build-${ruby_build_version}",
    }

    exec { "unzip-rbenv-sudo":
        require => File["${install_base}/rbenv-${rbenv_version}/plugins"],
        command => "/usr/bin/unzip /var/tmp/rbenv-sudo.zip -d ${install_base}/rbenv-${rbenv_version}/plugins/",
        creates => "${install_base}/rbenv-${rbenv_version}/plugins/rbenv-sudo-master",
    }



    # Set use of rbenv in the profile

    file { "/etc/profile.d/rbenv.sh":
        content => template("rbenv/rbenv.sh"),
        require => Exec["unzip-rbenv"],
    }

}


define rbenv::install_ruby( $ruby_version = $title ) {

    exec { "install-ruby-${ruby_version}":
        path        => "${rbenv::install_base}/rbenv-${rbenv::rbenv_version}/shims:${rbenv::install_base}/rbenv-${rbenv::rbenv_version}/bin:/usr/local/bin:/bin:/usr/bin",
        command     => "bash -c '. /etc/profile.d/rbenv.sh && rbenv install ${ruby_version}'",
        require     => [ Exec["unzip-ruby-build"], File["/etc/profile.d/rbenv.sh"] ],
        creates     => "${rbenv::install_base}/rbenv-${rbenv::rbenv_version}/versions/${ruby_version}",
        timeout     => "1000",
    }->
    exec { "install-bundler-for-${ruby_version}":
        environment => ["RBENV_ROOT=${rbenv::install_base}/rbenv-${rbenv::rbenv_version}"],
        path        => "${rbenv::install_base}/rbenv-${rbenv::rbenv_version}/shims:${rbenv::install_base}/rbenv-${rbenv::rbenv_version}/bin:/usr/local/bin:/bin:/usr/bin",
        command     => "bash -c '. /etc/profile.d/rbenv.sh && rbenv shell ${ruby_version} && gem install bundler && rbenv rehash'",
        creates     => "/opt/rbenv/rbenv-${rbenv::rbenv_version}/versions/${ruby_version}/bin/bundler"
    }

}
