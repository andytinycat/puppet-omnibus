class Ruby193 < FPM::Cookery::Recipe
  description 'The Ruby virtual machine'

  name 'ruby'
  version '2.0.0.247'
  revision 1
  homepage 'http://www.ruby-lang.org/'
  source 'http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p247.tar.bz2'
  sha256 '08e3d4b85b8a1118a8e81261f59dd8b4ddcfd70b6ae554e0ec5ceb99c3185e8a'

  maintainer '<github@tinycat.co.uk>'
  vendor     'fpm'
  license    'The Ruby License'

  section 'interpreters'

  platforms [:ubuntu, :debian] do
    build_depends 'autoconf',
                  'libreadline6-dev',
                  'bison',
                  'zlib1g-dev',
                  'libssl-dev',
                  'libncurses5-dev',
                  'build-essential',
                  'libffi-dev',
                  'libgdbm-dev'
    depends 'libffi6',
            'libncurses5',
            'libreadline6',
            'libssl1.0.0',
            'libtinfo5',
            'zlib1g',
            'libgdbm3'
  end

  platforms [:fedora, :redhat, :centos] do
    build_depends 'rpmdevtools',
                  'libffi-devel',
                  'autoconf',
                  'bison',
                  'libxml2-devel',
                  'libxslt-devel',
                  'openssl-devel',
                  'gdbm-devel'
    depends 'zlib',
            'libffi',
            'gdbm'
  end
  platforms [:fedora] do depends.push('openssl-libs') end
  platforms [:redhat, :centos] do depends.push('openssl') end

  def build
    configure :prefix => destdir,
              'enable-shared' => true,
              'disable-install-doc' => true,
              'with-opt-dir' => destdir
    make
  end

  def install
    make :install
    # Shrink package.
    rm_f "#{destdir}/lib/libruby-static.a"
    safesystem "strip #{destdir}/bin/ruby"
    safesystem "find #{destdir} -name '*.so' -or -name '*.so.*' | xargs strip"
  end
end

