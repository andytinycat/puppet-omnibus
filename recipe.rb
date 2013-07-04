class PuppetOmnibus < FPM::Cookery::Recipe
  homepage "https://github.com/andytinycat/puppet-omnibus"

  section "Utilities"
  name "puppet-omnibus"
  version "3.2.2"
  description "Puppet Omnibus package"
  revision 2
  vendor "fpm"
  maintainer "<github@tinycat.co.uk>"
  license "Apache 2.0 License"

  source '', :with => :noop

  omnibus_package true
  omnibus_recipes "omnibus/libyaml",
                  "omnibus/ruby",
                  "omnibus/facter-gem",
                  "omnibus/json_pure-gem",
                  "omnibus/hiera-gem",
                  "omnibus/rgen-gem",
                  "omnibus/ruby-augeas-gem",
                  "omnibus/ruby-shadow-gem",
                  "omnibus/puppet-gem",
                  "omnibus/init-script"

  omnibus_dir              "/opt/puppet-omnibus"
  omnibus_additional_paths "/etc/init.d/puppet"

  def build
    # Nothing
  end

  def install
    safesystem "rm -rf #{destdir}/bin || /bin/true"
    # Provide 'safe' binaries like Vagrant does
    destdir('bin').mkdir
    destdir('bin').install workdir('omnibus.bin'), 'puppet'
    destdir('bin').install workdir('omnibus.bin'), 'facter'
    destdir('bin').install workdir('omnibus.bin'), 'hiera'

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

