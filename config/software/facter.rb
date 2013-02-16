name "facter"
version "1.6.17"

dependencies ["ruby"]

build do
	gem "install facter -v #{version}"
end
