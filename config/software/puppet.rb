name "puppet"
version "3.1.0"

dependencies ["ruby", "facter", "hiera", "ruby-augeas", "ruby-shadow"]

build do
	gem "install puppet -v #{version}" 
	command "ln -s #{install_dir}/embedded/bin/puppet #{install_dir}/bin/puppet"
end
