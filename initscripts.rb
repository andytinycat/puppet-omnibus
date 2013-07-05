class InitScripts < FPM::Cookery::Recipe
  description 'Installs Puppet init scripts'

  name 'initscripts'
  version '1.0.0'
  source "nothing", :with => :noop

  def build
    # install
  end

  platforms [:ubuntu, :debian] do
    def install
      etc('init.d').install workdir("files/ubuntu/etc/init.d/puppet") => 'puppet'
    end
  end

  platforms [:fedora, :redhat, :centos] do
    def install
      etc('init.d').install workdir("files/redhat/etc/init.d/puppet") => 'puppet'
      etc('sysconfig').install workdir("files/redhat/etc/sysconfig/puppet") => 'puppet'
    end
  end

end
