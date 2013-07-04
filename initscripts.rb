class InitScript < FPM::Cookery::Recipe
  description 'Install Puppet init script'

  name 'init-script'
  version '1.0.0'
  source "nothing", :with => :noop

  def build
    # Do nothing
  end

  def install
    # Copy init-scripts to right place
#    platforms [:ubuntu, :debian] do
#      etc('init.d').install workdir("puppet.init.d") => 'puppet'
#    end
#    platforms [:fedora, :redhat, :centos] do
      etc('init.d').install workdir("../files/redhat/etc/init.d/puppet") => 'puppet'
      etc('sysconfig').install workdir("../files/redhat/etc/sysconfig/puppet") => 'puppet'
#    end
  end
end
