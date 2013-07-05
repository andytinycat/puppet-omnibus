class PuppetOmnibus < FPM::Cookery::Recipe
  homepage 'https://github.com/andytinycat/puppet-omnibus'

  section 'Utilities'
  name 'puppet-omnibus'
  version '3.2.2'
  description 'Puppet Omnibus package'
  revision 0
  vendor 'fpm'
  maintainer '<github@tinycat.co.uk>'
  license 'Apache 2.0 License'

  source '', :with => :noop

  omnibus_package true
  omnibus_recipes 'libyaml',
                  'ruby',
                  'puppet',
                  'initscripts'

  omnibus_dir              '/opt/puppet-omnibus'
  omnibus_additional_paths '/etc/init.d/puppet'
  platforms [:fedora, :redhat, :centos] do
    omnibus_additional_paths.push('/etc/sysconfig/puppet')
  end

  def build
    # Nothing
  end

  def install
    # Symlink binaries to PATH using update-alternatives
    with_trueprefix do
      create_post_install_hook
      create_pre_uninstall_hook
    end
  end

  private

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

      self.class.post_install(File.expand_path(f.path))
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

      self.class.pre_uninstall(File.expand_path(f.path))
    end
  end
end

