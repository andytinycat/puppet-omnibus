name "ruby-shadow"
version "2.1.4"

dependencies ["ruby"]

build do
  gem "install ruby-shadow -v #{version}"
end
