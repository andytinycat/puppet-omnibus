name "fog"
version "1.10.0"

dependencies ["ruby"]

build do
  gem "install fog -v #{version}" 
end
