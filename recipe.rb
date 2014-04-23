class PuppetOmnibus < FPM::Cookery::Recipe
  homepage 'https://github.com/scalefactory/puppet-omnibus'

  section 'Utilities'
  name 'scalefactory'
  version '3.4.2'
  description 'Puppet Omnibus package'
  vendor 'fpm'
  maintainer '<jon@scalefactory.com>'
  license 'Various'

  automation_packages = [
    'automation-hiera', 'automation-rubygems', 'automation-rubygem-right_http_connection',
    'automation-ruby-augeas', 'automation-hiera-gpg', 'automation-mcollective',
    'automation-ruby', 'automation-facter', 'automation-ruby-rdoc', 'automation-rubygem-rake',
    'automation-rubygem-flexmock', 'automation-rubygem-right_aws', 'automation-hiera-aws',
    'automation-rubygem-json', 'automation-mcollective-common', 'automation-rubygem-SyslogLogger',
    'automation-ruby-libs', 'automation-ruby-irb', 'automation-rubygem-gpgme',
    'automation-ruby-shadow', 'automation-rubygem-stomp', 'automation-rubygem-sf-deploy',
  ]

  conflicts automation_packages
  replaces  automation_packages
  provides  [ automation_packages, 'automation_ruby(abi)' ].flatten

  source '', :with => :noop

  omnibus_package true
  omnibus_dir     "/opt/#{name}"
  omnibus_recipes 'libyaml',
                  'ruby',
                  'puppet'


  if ENV.has_key?('BUILD_NUMBER')
    revision ENV['BUILD_NUMBER']
  else
    puts "Using revision number 0, as no BUILD_NUMBER passed - this may not be correct"
    revision 0
  end

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
    # Set paths to package scripts
    self.class.post_install builddir('post-install')
    self.class.pre_uninstall builddir('pre-uninstall')
  end

end

