class FacterGem < FPM::Cookery::Recipe
  description 'Facter as a gem'

  name 'facter'
  version '1.6.18'
  source "nothing", :with => :noop

  def build
    cleanenv_safesystem "/opt/puppet-omnibus/embedded/bin/gem install #{name} -v #{version}"
  end

  def install
    # Do nothing!
  end
end
