class InitScript < FPM::Cookery::Recipe
  description 'Install Puppet init script'

  name 'init-script'
  version '1.0.0'
  source "nothing", :with => :noop

  def build
    # Do nothing
  end

  def install
    # Copy init-script to right place
    case FPM::Cookery::Facts.target
    when :deb
      etc('init.d').install workdir("puppet.init.d-deb") => 'puppet'
    when :rpm
      etc('init.d').install workdir("puppet.init.d-rpm") => 'puppet'
      etc('sysconfig').install workdir("sysconfig-puppet-rpm") => 'puppet'
    end
    
  end
end
