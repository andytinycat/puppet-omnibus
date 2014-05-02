# -*- mode: ruby -*-
# vi: set ft=ruby :

if (/darwin/ =~ RUBY_PLATFORM) != nil
    vmware = "vmware_fusion"
else
    vmware = "vmware_workstation"
end

Vagrant.configure("2") do |config|

    config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", "1024"]
        v.customize ["modifyvm", :id, "--cpus", "2"]
    end

    config.vm.provider vmware do |v|
        v.vmx["memsize"]  = "1024"
        v.vmx["numvcpus"] = "2"
    end

    config.vm.define :centos6 do |centos6|

        box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-%s-nocm.box'

        centos6.vm.box      = "puppet_centos6_nocm"
        centos6.vm.box_url  = sprintf(box_url, 'vbox4210')

        centos6.vm.provider vmware do |v,override|
            override.vm.box_url = sprintf(box_url, 'fusion503')
        end

        centos6.vm.hostname = "centos6"

    end

    config.vm.define :ubuntu12 do |ubuntu12|

        box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-%s-nocm.box'

        ubuntu12.vm.box      = "puppet_ubuntu-server-12042-x64-nocm"
        ubuntu12.vm.box_url  = sprintf(box_url, 'vbox4210')

        ubuntu12.vm.provider vmware do |v,override|
            override.vm.box_url = sprintf(box_url, 'fusion503')
        end

        ubuntu12.vm.hostname = "ubuntu12"

    end

    config.vm.provision "shell", path: "rbenv.sh"

end
