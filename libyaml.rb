class Ruby193 < FPM::Cookery::Recipe
  description 'LibYAML is a YAML 1.1 parser and emitter written in C'

  name 'libyaml'
  version '0.1.4'
  revision 1
  homepage 'http://pyyaml.org/wiki/LibYAML'
  source 'http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz'
  sha256 '7bf81554ae5ab2d9b6977da398ea789722e0db75b86bffdaeb4e66d961de6a37'

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
