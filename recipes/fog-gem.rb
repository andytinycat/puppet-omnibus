class FogGem < FPM::Cookery::Recipe
  description 'Fog as a gem'

  name 'fog'
  version '1.10.0'
  source "nothing", :with => :noop

  build_depends 'libxml2-dev', 'libxslt1-dev'
  depends 'libxml2', 'libxslt1.1'

  def build
    cleanenv_safesystem "/opt/puppet-omnibus/embedded/bin/gem install #{name} -v #{version}"
  end

  def install
    # Do nothing!
  end
end
