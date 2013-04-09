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
    etc('init.d').install workdir("puppet.init.d") => 'puppet'
  end
end
