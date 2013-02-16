name "ruby-augeas"
version "0.4.1"

dependencies ["ruby"]

build do
	gem "install ruby-augeas -v #{version}"
end
