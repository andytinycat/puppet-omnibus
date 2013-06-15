class Symlinks < FPM::Cookery::Recipe
  description 'Set up symlinks for Puppet, Facter and Hiera'

  name 'symlinks'
  version '1.0.0'
  source "nothing", :with => :noop

  def build
    # Do nothing
  end

  def install
    safesystem "rm -rf /opt/puppet-omnibus/bin || /bin/true"
    safesystem "mkdir -p /opt/puppet-omnibus/bin"
    safesystem "ln -s /opt/puppet-omnibus/embedded/bin/puppet /opt/puppet-omnibus/bin/puppet"
    safesystem "ln -s /opt/puppet-omnibus/embedded/bin/hiera /opt/puppet-omnibus/bin/hiera"
    safesystem "ln -s /opt/puppet-omnibus/embedded/bin/facter /opt/puppet-omnibus/bin/facter"
  end
end
