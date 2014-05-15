class Ruby193 < FPM::Cookery::Recipe
  description 'LibYAML is a YAML 1.1 parser and emitter written in C'

  name 'libyaml'
  version '0.1.5'
  revision 1
  homepage 'http://pyyaml.org/wiki/LibYAML'
  source 'http://pyyaml.org/download/libyaml/yaml-0.1.5.tar.gz'
  sha256 'fa87ee8fb7b936ec04457bc044cd561155e1000a4d25029867752e543c2d3bef'

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
