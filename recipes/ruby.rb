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

  section 'libraries'
  
  case FPM::Cookery::Facts.platform
  when :debian, :ubuntu
    build_depends 'autoconf', 'libreadline6-dev', 'bison', 'zlib',
                  'libssl-dev', 'libncurses5-dev', 'build-essential',
                  'libffi-dev', 'libgdbm-dev'
    
    depends 'libffi6', 'libncurses5', 'libreadline6', 'libssl1.0.0', 'libtinfo5',
            'zlib1g', 'libgdbm3'
    
  when :fedora
    build_depends 'gcc', 'gcc-c++', 'glibc', 'make', 'autoconf', 'gdbm-devel', 
                  'ncurses-devel', 'libdb-devel', 'libffi-devel',
                  'readline-devel', 'tk-devel', 'openssl-devel'
      
    depends 'coreutils','glibc', 'pkgconfig', 'openssl-libs',
            'ncurses-libs', 'zlib','gdbm','libffi','readline'
      
  when :redhat, :centos
    build_depends 'gcc', 'gcc-c++', 'glibc', 'make',
                  'autoconf', 'gdbm-devel', 'ncurses-devel', 'libdb-devel', 
                  'libffi-devel', 'readline-devel', 'tk-devel', 'openssl-devel'
    
      depends 'coreutils','glibc', 'pkgconfig', 'openssl','ncurses-libs',
              'zlib','gdbm','libffi','readline'
  end

    

  def build
    configure :prefix => "/opt/puppet-omnibus/embedded", 'disable-install-doc' => true,
              'with-opt-dir' => '/opt/puppet-omnibus/embedded'
    make
  end

  def install
    make :install
  end
end
