class RubyAugeasGem < FPM::Cookery::Recipe
  description 'Ruby-augeas as a gem'

  name 'ruby-augeas'
  version '0.5.0'
  source "nothing", :with => :noop

  case FPM::Cookery::Facts.target
  when :deb
    build_depends 'libaugeas-dev', 'pkg-config'
    depends 'libaugeas0', 'pkg-config'
  when :rpm
    build_depends 'augeas-devel'
    depends 'augeas-libs','glibc'
  end  
  
  def build
    cleanenv_safesystem "/opt/puppet-omnibus/embedded/bin/gem install #{name} -v #{version}"
  end

  def install
    # Do nothing!
  end
end
