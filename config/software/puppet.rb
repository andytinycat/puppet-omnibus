name "puppet"
version "3.1.0"

dependencies ["ruby", "facter", "hiera"]

build do
	gem "install puppet -v #{version}" 
end
