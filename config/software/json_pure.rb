name "json_pure"
version "1.7.7"

dependencies ["ruby", "json_pure"]

build do
	gem "install json_pure -v #{version}" 
end
