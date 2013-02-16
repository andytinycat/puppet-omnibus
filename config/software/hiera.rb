name "hiera"
version "1.1.2"

dependencies ["ruby", "json_pure"]

build do
	gem "install hiera -v #{version}" 
end
