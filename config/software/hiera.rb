name "hiera"
version "1.1.2"

dependencies ["ruby", "json_pure"]

build do
	gem "install hiera -v #{version}" 
	command "ln -s #{install_dir}/embedded/bin/hiera #{install_dir}/bin/hiera"
end
