# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.synced_folder "./", "/vagrant"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  config.vm.define :centos6_6 do |centos|
    centos.vm.box = "chef/centos-6.6"
    centos.vm.provision "shell", :path => "./provisioning/centos.sh", :privileged => false
  end

  config.vm.define :ubuntu12_04 do |ubuntu|
    ubuntu.vm.box = "chef/ubuntu-12.04"
    ubuntu.vm.provision "shell", :path => "./provisioning/ubuntu.sh", :privileged => false
  end

end
