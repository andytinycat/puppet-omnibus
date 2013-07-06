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
  omnibus_dir     "/opt/#{name}"
  omnibus_recipes 'libyaml',
                  'ruby',
                  'puppet',
                  'aws'

  # Set up paths to initscript and config files per platform
  platforms [:ubuntu, :debian] do
    config_files '/etc/puppet/puppet.conf',
                 '/etc/init.d/puppet',
                 '/etc/default/puppet'
  end
  platforms [:fedora, :redhat, :centos] do
    config_files '/etc/puppet/puppet.conf',
                 '/etc/init.d/puppet',
                 '/etc/sysconfig/puppet'
  end
  omnibus_additional_paths config_files

  def build
    # Nothing
  end

  def install
    # Nothing
  end

end

