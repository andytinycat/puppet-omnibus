class RubyShadowGem < FPM::Cookery::Recipe
  description 'Ruby-shadow as a gem'

  name 'ruby-shadow'
  version '2.2.0'
  source "nothing", :with => :noop

  def build
    cleanenv_safesystem "/opt/puppet-omnibus/embedded/bin/gem install #{name} -v #{version}"
  end

  def install
    # Do nothing!
  end
end
