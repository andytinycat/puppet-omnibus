# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.synced_folder "./", "/vagrant"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "1024"]
    v.customize ["modifyvm", :id, "--cpus", "2"]
  end

  config.vm.define :centos6 do |node1|
    node1.vm.hostname = "centos6"
    node1.vm.box      = "centos6"
    node1.vm.box_url  = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
  end

  config.vm.define :fedora18 do |node2|
    node2.vm.hostname = "fedora18"
    node2.vm.box      = "fedora18"
    node2.vm.box_url  = "http://puppet-vagrant-boxes.puppetlabs.com/fedora-18-x64-vbox4210.box"
  end

  config.vm.define :precise do |node3|
    node3.vm.hostname = "precise"
    node3.vm.box      = "precise"
    node3.vm.box_url  = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box"
  end

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet_provisioning"
    puppet.manifest_file  = "site.pp"
  end

end
