class PuppetOmnibus < FPM::Cookery::Recipe
  homepage "https://github.com/andytinycat/puppet-omnibus"

  section "Utilities"
  name "puppet-omnibus"
  version "3.1.0"
  description "Puppet Omnibus package"
  revision 5
  vendor "f3d"
  maintainer "Forward3D Development <agency-devs@forward.co.uk>"
  license "Apache 2.0 License"

  omnibus_package true
  omnibus_recipes "ruby", "facter-gem", "json_pure-gem", "hiera-gem", "ruby-augeas-gem", \
                  "ruby-shadow-gem", "fog-gem", "aws-sdk-gem", "puppet-gem", "init-script"
  omnibus_dir     "/opt/puppet-omnibus"
end
