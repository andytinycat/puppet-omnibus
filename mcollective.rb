class Mcollective < FPM::Cookery::Recipe
  description 'Marionette Collective server orchestration framework'

  name 'mcollective'
  version '2.5.0'
  homepage 'http://puppetlabs.com/mcollective'
  source "https://github.com/puppetlabs/marionette-collective/archive/#{version}.tar.gz"
  sha256 "85baf42c1367fe9596e160ac4036eacbf8923bb540006499c00188eaf327b95d"

  def build
    # Install gems using the gem command from destdir
    gem_install 'stomp',              '1.3.2'
  end

  def install 
    cleanenv_safesystem "#{destdir}/bin/ruby install.rb --plugindir=#{destdir}/share/mcollective/plugins"
    etc('mcollective/plugin.d').mkpath
    etc('mcollective/ssl/clients').mkpath

    # Install init-scripts 
    install_files
  end

  private

  def gem_install(name, version = nil)
    v = version.nil? ? '' : "-v #{version}"
    cleanenv_safesystem "#{destdir}/bin/gem install --no-ri --no-rdoc #{v} #{name}"
  end

  platforms [:ubuntu, :debian] do
    def install_files
      etc('default').install workdir('ext/mcollective/debian/default') => 'mcollective'
      etc('init.d').install workdir('ext/mcollective/debian/mcollective.init') => 'mcollective'
      chmod 0755, etc('init.d/mcollective')

      # Set the real daemon path in initscript defaults
      safesystem "echo mcollectived=#{destdir}/sbin/mcollectived >> /etc/default/mcollective"
    end
  end

  platforms [:fedora, :redhat, :centos] do
    def install_files
      etc('init.d').install workdir('ext/mcollective/redhat/mcollective.init') => 'mcollective'
      chmod 0755, etc('init.d/mcollective')
      etc('sysconfig').install workdir('ext/mcollective/redhat/sysconfig') => 'mcollective'

      # Set the real daemon path in initscript defaults
      safesystem "echo mcollectived=#{destdir}/sbin/mcollectived >> /etc/sysconfig/mcollective"
    end
  end

end
