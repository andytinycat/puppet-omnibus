class AWSSDKGem < FPM::Cookery::Recipe
  description 'Aws-sdk as a gem'

  name 'aws-sdk'
  version '1.8.5'
  source "nothing", :with => :noop

  platforms [:ubuntu, :debian] do
    build_depends 'libxml2-dev', 'libxslt1-dev'
    depends 'libxml2', 'libxslt1.1'
  end

  platforms [:fedora, :redhat, :centos] do
    build_depends 'libxml2-devel', 'libxslt-devel'
    depends 'libxml2', 'libxslt'
  end

  def build
    cleanenv_safesystem "/opt/puppet-omnibus/embedded/bin/gem install #{name} -v #{version}"
  end

  def install
    # Do nothing!
  end
end
