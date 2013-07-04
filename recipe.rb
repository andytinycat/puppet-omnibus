class PuppetOmnibus < FPM::Cookery::Recipe
  homepage "https://github.com/andytinycat/puppet-omnibus"

  section "Utilities"
  name "puppet-omnibus"
  version "3.2.1"
  description "Puppet Omnibus package"
  revision 1
  vendor "fpm"
  maintainer "<github@tinycat.co.uk>"
  license "Apache 2.0 License"

  source '', :with => :noop

  omnibus_package true
  omnibus_recipes "omnibus/libyaml",
                  "omnibus/ruby",
                  "omnibus/facter-gem",
                  "omnibus/json_pure-gem",
                  "omnibus/hiera-gem",
                  "omnibus/rgen-gem",
                  "omnibus/ruby-augeas-gem",
                  "omnibus/ruby-shadow-gem",
                  "omnibus/puppet-gem",
                  "omnibus/symlinks",
                  "omnibus/init-script"

  omnibus_dir              "/opt/puppet-omnibus"
  omnibus_additional_paths "/etc/init.d/puppet"

  def build
    # Nothing
  end

  def install
    # Nothing
  end

end
