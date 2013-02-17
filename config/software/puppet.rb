name "puppet"
version "3.1.0"

dependencies ["ruby", "facter", "hiera", "ruby-augeas", "ruby-shadow"]

build do
	gem "install puppet -v #{version}" 
	command "if [ ! -L #{install_dir}/bin/puppet ]; then ln -s #{install_dir}/embedded/bin/puppet #{install_dir}/bin/puppet; fi"
  command "cp #{Omnibus.root}/init-script/puppet /etc/init.d/puppet"
end
