class InitScript < FPM::Cookery::Recipe
  description 'Install Puppet init script'

  name 'init-script'
  version '1.0.0'
  source "nothing", :with => :noop

  extra_paths "/etc/init.d/puppet"

  def build
    # Do nothing
  end

  def install
    # Copy init-script to right place
    safesystem "cp ../../init-script/puppet /etc/init.d/puppet"
    safesystem "chown root:root /etc/init.d/puppet"
    safesystem "chmod 0755 /etc/init.d/puppet"
  end
end
