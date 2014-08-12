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
    'automation-puppet',
  ]

  conflicts automation_packages
  replaces  automation_packages

  platforms [:ubuntu, :debian] do
    provides automation_packages
  end

  platforms [:fedora, :redhat, :centos] do
    provides  [ automation_packages, 'automation-ruby(abi) = 2.0', 
        'automation-ruby(x86-64)', '/opt/automation/usr/bin/ruby' ].flatten
  end

  source '', :with => :noop

  omnibus_package true
  omnibus_dir     "/opt/#{name}"
  omnibus_recipes 'libyaml',
                  'ruby',
                  'mcollective',
                  'puppet',
                  'aws'


  if ENV.has_key?('PKG_VERSION')
    revision ENV['PKG_VERSION']
  else
    puts "Using revision number 0, as no PKG_VERSION passed - this may not be correct"
    revision 0
  end

  # Set up paths to initscript and config files per platform
  platforms [:ubuntu, :debian] do
    config_files '/etc/puppet/puppet.conf',
                 '/etc/init.d/puppet',
                 '/etc/default/puppet',
                 '/etc/default/mcollective',
                 '/etc/mcollective/server.cfg',
                 '/etc/mcollective/client.cfg'
  end
  platforms [:fedora, :redhat, :centos] do
    config_files '/etc/puppet/puppet.conf',
                 '/etc/init.d/puppet',
                 '/etc/sysconfig/puppet',
                 '/etc/sysconfig/mcollective',
                 '/etc/mcollective/server.cfg',
                 '/etc/mcollective/client.cfg'
  end

  omnibus_additional_paths config_files, '/var/lib/puppet/ssl/certs',
                                         '/var/run/puppet',
                                         '/etc/mcollective/plugin.d',
                                         '/etc/mcollective/ssl/clients',
                                         '/etc/init.d/mcollective',
                                         '/etc/profile.d/puppet.sh'
                                           

  def build
    # Nothing
  end

  def install
    # Set paths to package scripts
    self.class.post_install builddir('post-install')
    self.class.pre_uninstall builddir('pre-uninstall')
    self.class.post_uninstall builddir('post-uninstall')
  end

end

