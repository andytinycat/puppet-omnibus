class RubyAugeasGem < FPM::Cookery::Recipe
  description 'Ruby-augeas as a gem'

  name 'ruby-augeas'
  version '0.5.0'
  source "nothing", :with => :noop

  platforms [:ubuntu, :debian] do
    build_depends 'libaugeas-dev', 'pkg-config'
    depends 'libaugeas0', 'pkg-config'
  end

  platforms [:fedora, :redhat, :centos] do
    build_depends 'augeas-devel', 'pkgconfig'
    depends 'augeas-libs', 'pkgconfig'
  end

  def build
    cleanenv_safesystem "/opt/puppet-omnibus/embedded/bin/gem install #{name} -v #{version}"
  end

  def install
    # Do nothing!
  end
end
