name "ruby-aws"
version "1.6.0"

dependencies ["ruby"]

build do
  gem "install ruby-aws -v #{version}" 
end
