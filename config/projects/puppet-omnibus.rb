name "puppet-omnibus"

install_path 		"/opt/puppet-omnibus"
build_version   "3.1.0"
build_iteration "1"

maintainer "Forward Internet Group"
url "http://www.forward.co.uk"
description "Puppet, Facter and Hiera packaged with a source-built Ruby"

# Software to build
dependencies ["ruby", "puppet"]

# Dependency the OS package will be built with
runtime_dependencies ["libyaml-0-2", "openssl", "zlib1g", "libxml2"]

# Conflicts with existing Puppet package
conflicts ["puppet", "puppet-common"]
