name "facter"
version "1.6.17"

dependencies ["ruby"]

build do
	gem "install facter -v #{version}"
	command "ln -s #{install_dir}/embedded/bin/facter #{install_dir}/bin/facter"
end
