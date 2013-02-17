name "hiera"
version "1.1.2"

dependencies ["ruby", "json_pure"]

build do
  gem "install hiera -v #{version}" 
  command "if [ ! -L #{install_dir}/bin/hiera ]; then ln -s #{install_dir}/embedded/bin/hiera #{install_dir}/bin/hiera; fi"
end
