class Ruby193 < FPM::Cookery::Recipe
  description 'LibYAML is a YAML 1.1 parser and emitter written in C'

  name 'libyaml'
  version '0.1.6'
  revision 1
  homepage 'http://pyyaml.org/wiki/LibYAML'
  source 'http://pyyaml.org/download/libyaml/yaml-0.1.6.tar.gz'
  sha256 '7da6971b4bd08a986dd2a61353bc422362bd0edcc67d7ebaac68c95f74182749'

  maintainer '<beddari@deploy.no>'
  vendor     'fpm'
  license    'MIT license'

  section 'libraries'

  platforms [:ubuntu, :debian] do
	build_depends 'build-essential'
  end

  platforms [:fedora, :redhat, :centos] do
	build_depends 'gcc', 'gcc-c++', 'make'
  end

  def build
    configure :prefix => destdir
    make
  end

  def install
    make :install
  end
end
