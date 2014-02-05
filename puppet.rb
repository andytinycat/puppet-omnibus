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
    gem_install 'zcollective',        '0.0.9'
    gem_install name,                 version

    # Download init scripts and conf
    build_files
  end

  def install
    # Install init-script and puppet.conf
    install_files

    # Provide 'safe' binaries in /opt/<package>/bin like Vagrant does
    rm_rf "#{destdir}/../bin"
    destdir('../bin').mkdir
    destdir('../bin').install workdir('omnibus.bin'), 'puppet'
    destdir('../bin').install workdir('omnibus.bin'), 'facter'
    destdir('../bin').install workdir('omnibus.bin'), 'hiera'
    destdir('../bin').install workdir('omnibus.bin'), 'mco'
    destdir('../bin').install workdir('omnibus.bin'), 'zcollective'

    # Symlink binaries to PATH using update-alternatives
    with_trueprefix do
      create_post_install_hook
      create_pre_uninstall_hook
    end
  end

  private

  def gem_install(name, version = nil)
    v = version.nil? ? '' : "-v #{version}"
    cleanenv_safesystem "#{destdir}/bin/gem install --no-ri --no-rdoc #{v} #{name}"
  end

  platforms [:ubuntu, :debian] do
    def build_files
      system "curl -O https://raw.github.com/puppetlabs/puppet/#{version}/ext/debian/puppet.conf"
      system "curl -O https://raw.github.com/puppetlabs/puppet/#{version}/ext/debian/puppet.init"
      system "curl -O https://raw.github.com/puppetlabs/puppet/#{version}/ext/debian/puppet.default"
      # Set the real daemon path in initscript defaults
      system "echo DAEMON=#{destdir}/bin/puppet >> puppet.default"
    end
    def install_files
      etc('puppet').mkdir
      etc('puppet').install builddir('puppet.conf') => 'puppet.conf'
      etc('init.d').install builddir('puppet.init') => 'puppet'
      etc('default').install builddir('puppet.default') => 'puppet'
      chmod 0755, etc('init.d/puppet')
    end
  end

  platforms [:fedora, :redhat, :centos] do
    def build_files
      safesystem "curl -O https://raw.github.com/puppetlabs/puppet/#{version}/ext/redhat/puppet.conf"
      safesystem "curl -O https://raw.github.com/puppetlabs/puppet/#{version}/ext/redhat/client.init"
      safesystem "curl -O https://raw.github.com/puppetlabs/puppet/#{version}/ext/redhat/client.sysconfig"
      safesystem "curl -O https://raw.github.com/puppetlabs/marionette-collective/master/etc/client.cfg.dist"
      safesystem "curl -O https://raw.github.com/puppetlabs/marionette-collective/master/etc/server.cfg.dist"
      # Set the real daemon path in initscript defaults
      safesystem "echo PUPPETD=#{destdir}/bin/puppet >> client.sysconfig"
    end
    def install_files
      etc('puppet').mkdir
      etc('puppet').install builddir('puppet.conf') => 'puppet.conf'
      etc('init.d').install builddir('client.init') => 'puppet'
      etc('sysconfig').install builddir('client.sysconfig') => 'puppet'
      chmod 0755, etc('init.d/puppet')
      etc('mcollective').mkdir
      etc('mcollective').install builddir('server.cfg.dist') => 'server.cfg'
      etc('mcollective').install builddir('client.cfg.dist') => 'client.cfg'
    end
  end

  def create_post_install_hook
    File.open(builddir('post-install'), 'w', 0755) do |f|
      f.write <<-__POSTINST
#!/bin/sh
set -e

BIN_PATH="#{destdir}/bin"
BINS="puppet facter hiera"

for BIN in $BINS; do
  update-alternatives --install /usr/bin/$BIN $BIN $BIN_PATH/$BIN 100
done

exit 0
      __POSTINST
    end
  end

  def create_pre_uninstall_hook
    File.open(builddir('pre-uninstall'), 'w', 0755) do |f|
      f.write <<-__PRERM
#!/bin/sh
set -e

BIN_PATH="#{destdir}/bin"
BINS="puppet facter hiera"

if [ "$1" != "upgrade" ]; then
  for BIN in $BINS; do
    update-alternatives --remove $BIN $BIN_PATH/$BIN
  done
fi

exit 0
      __PRERM
    end
  end

end
