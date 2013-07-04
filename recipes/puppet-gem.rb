class PuppetGem < FPM::Cookery::Recipe
  description 'Puppet as a gem'

  name 'puppet'
  version '3.2.2'
  source "nothing", :with => :noop

  def build
    cleanenv_safesystem "/opt/puppet-omnibus/embedded/bin/gem install #{name} -v #{version}"
  end

  def install
    # Do nothing!
  end
end
