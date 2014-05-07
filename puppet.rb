class PuppetGem < FPM::Cookery::Recipe
  description 'Puppet gem stack'

  name 'puppet'
  version '3.4.2'

  source "nothing", :with => :noop

  platforms [:ubuntu, :debian] do
    build_depends 'libaugeas-dev', 'pkg-config'
    depends 'libaugeas0', 'pkg-config'
  end

  platforms [:fedora, :redhat, :centos] do
    build_depends 'augeas-devel', 'pkgconfig'
    depends 'augeas-libs', 'pkgconfig'
  end

  def build
    # Install gems using the gem command from destdir
    gem_install 'facter',             '1.7.4'
    gem_install 'json_pure',          '1.8.0'
    gem_install 'hiera',              '1.3.1'
    gem_install 'deep_merge',         '1.0.0'
    gem_install 'rgen',               '0.6.5'
    gem_install 'ruby-augeas',        '0.4.1'
    gem_install 'ruby-shadow',        '2.2.0'
    gem_install 'gpgme',              '2.0.2'
    gem_install 'mcollective-client', '2.4.0'
    gem_install 'mcollective',        '2.2.3'
    gem_install 'zcollective',        '0.0.9'
    gem_install 'unicorn',            '4.8.2'
    gem_install 'rack',               '1.5.2'
    gem_install 'stomp',              '1.2.2'
    gem_install name,                 version

    # Download init scripts and conf
    build_files
  end

  def install
    # create paths and install common config
    install_files_common

    # Install init-scripts and OS specific config
    install_files

    # Provide 'safe' binaries in /opt/<package>/bin like Vagrant does
    rm_rf "#{destdir}/../bin"
    destdir('../bin').mkdir
    destdir('../bin').install workdir('omnibus.bin'), 'puppet'
    destdir('../bin').install workdir('omnibus.bin'), 'facter'
    destdir('../bin').install workdir('omnibus.bin'), 'hiera'
    destdir('../bin').install workdir('omnibus.bin'), 'mco'
    destdir('../bin').install workdir('omnibus.bin'), 'zcollective'
     
    with_trueprefix do
      # Symlink binaries to PATH using update-alternatives
      create_post_install_hook
      create_pre_uninstall_hook

      # Add/remove puppet user/group
      append_users_to_post_install_hook
      create_post_uninstall_hook
    end
  end

  private

  def gem_install(name, version = nil)
    v = version.nil? ? '' : "-v #{version}"
    cleanenv_safesystem "#{destdir}/bin/gem install --no-ri --no-rdoc #{v} #{name}"
  end

  def install_files_common 
      etc('puppet').mkdir
      var('lib/puppet/ssl/certs').mkpath
      chmod 0771, var('lib/puppet/ssl')
      var('run/puppet').mkdir
      destdir('share/puppet/ext/rack/files').mkpath
      destdir('share/puppet/ext/rack/files').install workdir('ext/puppet/rack/config.ru')  => 'config.ru'

      etc('mcollective/plugin.d').mkpath
      etc('mcollective/ssl/clients').mkpath
      etc('mcollective').install workdir('ext/mcollective/server.cfg.dist') => 'server.cfg'
      etc('mcollective').install workdir('ext/mcollective/client.cfg.dist') => 'client.cfg'
  end

  platforms [:ubuntu, :debian] do
    def build_files
    end
    def install_files
      etc('puppet').install workdir('ext/puppet/debian/puppet.conf') => 'puppet.conf'
      etc('init.d').install workdir('ext/puppet/debian/puppet.init') => 'puppet'
      etc('default').install workdir('ext/puppet/debian/puppet.default') => 'puppet'
      chmod 0755, etc('init.d/puppet')

      etc('init.d').install workdir('ext/mcollective/debian/mcollective.init') => 'mcollective'
      chmod 0755, etc('init.d/mcollective')

      # Set the real daemon path in initscript defaults
      safesystem "echo DAEMON=#{destdir}/bin/puppet >> /etc/default/puppet"
    end
  end

  platforms [:fedora, :redhat, :centos] do
    def build_files
    end
    def install_files
      etc('puppet').install workdir('ext/puppet/redhat/puppet.conf') => 'puppet.conf'
      etc('init.d').install workdir('ext/puppet/redhat/client.init') => 'puppet'
      etc('sysconfig').install workdir('ext/puppet/redhat/client.sysconfig') => 'puppet'
      chmod 0755, etc('init.d/puppet')

      etc('init.d').install workdir('ext/mcollective/redhat/mcollective.init') => 'mcollective'
      chmod 0755, etc('init.d/mcollective')
      
      # Set the real daemon path in initscript defaults
      safesystem "echo PUPPETD=#{destdir}/bin/puppet >> /etc/sysconfig/puppet"
    end
  end


  def create_post_install_hook
    File.open(builddir('post-install'), 'w', 0755) do |f|
      f.write <<-__POSTINST
#!/bin/sh
set -e

BIN_PATH="#{destdir}/bin"
BINS="puppet facter hiera mco"

for BIN in $BINS; do
  update-alternatives --install /usr/bin/$BIN $BIN $BIN_PATH/$BIN 100
done

      __POSTINST
    end
  end

  def create_pre_uninstall_hook
    File.open(builddir('pre-uninstall'), 'w', 0755) do |f|
      f.write <<-__PRERM
#!/bin/sh
set -e

BIN_PATH="#{destdir}/bin"
BINS="puppet facter hiera mco"

if [ "$1" != "upgrade" ]; then
  for BIN in $BINS; do
    update-alternatives --remove $BIN $BIN_PATH/$BIN
  done
fi

      __PRERM
    end
  end

  def create_post_uninstall_hook
    File.open(builddir('post-uninstall'), 'w', 0755) do |f|
      f.write <<-__POSTRM
#!/bin/sh
set -e

# Disabled as stock packages don't do it
# userdel puppet || true

exit 0
      __POSTRM
    end
  end


  platforms [:fedora, :redhat, :centos] do
    def append_users_to_post_install_hook
      File.open(builddir('post-install'), 'a', 0755) do |f|
        f.write <<-__POSTINST

getent group puppet &>/dev/null || groupadd -r puppet -g 52 &>/dev/null
getent passwd puppet &>/dev/null || \
useradd -r -u 52 -g puppet -d %{_localstatedir}/lib/puppet -s /sbin/nologin \
    -c "Puppet" puppet &>/dev/null

chown puppet:puppet %{_localstatedir}/lib/puppet
chown puppet %{_localstatedir}/lib/puppet/ssl
chown puppet %{_localstatedir}/lib/puppet/ssl/certs


exit 0
        __POSTINST
      end
    end
  end

  platforms [:ubuntu, :debian] do
    def append_users_to_post_install_hook
      File.open(builddir('post-install'), 'a', 0755) do |f|
        f.write <<-__POSTINST

if ! getent passwd puppet > /dev/null; then
    adduser --quiet --system --group --home /var/lib/puppet  \
    -no-create-home \
    --gecos "Puppet configuration management daemon" \
    puppet
fi

chown puppet:puppet /var/lib/puppet
chown puppet /var/lib/puppet/ssl
chown puppet /var/lib/puppet/ssl/certs

exit 0
        __POSTINST
      end
    end
  end

end
