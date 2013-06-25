class PuppetOmnibus < FPM::Cookery::Recipe
  homepage "https://github.com/andytinycat/puppet-omnibus"

  section "Utilities"
  name "puppet-omnibus"
  version "3.2.2"
  description "Puppet Omnibus package"
  revision 1
  vendor "fpm"
  maintainer "<github@tinycat.co.uk>"
  license "Apache 2.0 License"

  source '', :with => :noop

  omnibus_package true
  omnibus_recipes "libyaml", "ruby", "facter-gem", "json_pure-gem", "hiera-gem",
                  "ruby-augeas-gem", "ruby-shadow-gem", "fog-gem", "aws-sdk-gem",
                  "puppet-gem", "symlinks", "init-script", "puppetd"
  omnibus_dir     "/opt/puppet-omnibus"
  case FPM::Cookery::Facts.target
  when :deb
    omnibus_additional_paths "/etc/init.d/puppet"
  when :rpm
    omnibus_additional_paths "/etc/init.d/puppet", "/etc/sysconfig/puppet"
  end

  def build
    # Nothing
  end

  def install
    # Nothing
  end

end
