class InitScripts < FPM::Cookery::Recipe
  description 'Installs Puppet init scripts'

  name 'initscripts'
  version '1.0.0'
  source "nothing", :with => :noop

  platforms [:ubuntu, :debian] do
    #etc('init.d').install workdir("puppet.init.d") => 'puppet'
  end
  platforms [:fedora, :redhat, :centos] do
    #etc('init.d').install workdir("files/redhat/etc/init.d/puppet") => 'puppet'
    #etc('sysconfig').install workdir("files/redhat/etc/sysconfig/puppet") => 'puppet'
  end

  def build
    # Do nothing
  end

  def install
    # Do nothing 
  end
end
