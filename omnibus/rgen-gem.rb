class RgenGem < FPM::Cookery::Recipe
  description 'rgen as a gem'

  name 'rgen'
  version '0.6.5'
  source "nothing", :with => :noop

  def build
    cleanenv_safesystem "/opt/puppet-omnibus/embedded/bin/gem install #{name} -v #{version}"
  end

  def install
    # Do nothing!
  end
end
