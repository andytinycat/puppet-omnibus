class HieraGem < FPM::Cookery::Recipe
  description 'Hiera as a gem'

  name 'hiera'
  version '1.2.1'
  source "nothing", :with => :noop

  def build
    cleanenv_safesystem "/opt/puppet-omnibus/embedded/bin/gem install #{name} -v #{version}"
  end

  def install
    # Do nothing!
  end
end
