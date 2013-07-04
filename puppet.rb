class PuppetGem < FPM::Cookery::Recipe
  description 'Puppet gem stack'

  name 'puppet'
  version '3.2.2'

  source "nothing", :with => :noop

  def build
    gem_install 'facter',      '1.7.1'
    gem_install 'json_pure',   '1.6.3'
    gem_install 'hiera',       '1.2.1'
    gem_install 'rgen',        '0,6.5'
    gem_install 'ruby-augeas', '0.4.1'
    gem_install 'ruby-shadow', '1.4.1'
    gem_install name,          version
  end

  def install
    # Do nothing!
  end
end
