class JsonPureGem < FPM::Cookery::Recipe
  description 'JSON pure Ruby gem'

  name 'json_pure'
  version '1.7.7'
  source "nothing", :with => :noop

  def build
    cleanenv_safesystem "/opt/puppet-omnibus/embedded/bin/gem install #{name} -v #{version}"
  end

  def install
    # Do nothing!
  end
end
