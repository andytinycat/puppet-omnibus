class Ruby193 < FPM::Cookery::Recipe
  description 'The Ruby virtual machine'

  name 'ruby'
  version '1.9.3.429'
  revision 1
  homepage 'http://www.ruby-lang.org/'
  source 'http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p429.tar.bz2'
  sha256 '9d8949c24cf6fe810b65fb466076708b842a3b0bac7799f79b7b6a8791dc2a70'

  maintainer '<github@tinycat.co.uk>'
  vendor     'fpm'
  license    'The Ruby License'

  section 'interpreters'

  platforms [:ubuntu, :debian] do
    build_depends 'autoconf', 'libreadline6-dev', 'bison', 'zlib1g-dev',
                  'libssl-dev', 'libyaml-dev', 'libncurses5-dev', 'build-essential',
                  'libffi-dev', 'libgdbm-dev'
    depends 'libffi6', 'libncurses5', 'libreadline6', 'libssl1.0.0', 'libtinfo5',
            'libyaml-0-2', 'zlib1g', 'libgdbm3'
  end

  platforms [:fedora, :redhat, :centos] do
    build_depends 'rpmdevtools', 'libyaml-devel', 'libffi-devel', 'autoconf', 'bison',
                  'libxml2-devel', 'libxslt-devel', 'openssl-devel', 'gdbm-devel'
    depends 'zlib', 'openssl', 'libyaml', 'libffi', 'gdbm'
  end

  def build
    configure :prefix => "/opt/puppet-omnibus/embedded", 'disable-install-doc' => true
    make
  end

  def install
    make :install
  end
end
