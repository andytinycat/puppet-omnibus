class Puppetd < FPM::Cookery::Recipe
  description 'Install puppetd script'

  name 'puppetd-script'
  version '1.0.0'
  source "nothing", :with => :noop

  def build
    # Do nothing
  end

  def install
    # Copy init-script to right place
    case FPM::Cookery::Facts.target
    when :rpm
      opt('puppet-omnibus/bin').install workdir("puppetd-rpm") => 'puppetd'
    end
    
  end
end
