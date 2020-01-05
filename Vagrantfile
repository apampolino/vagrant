# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.define "web2" do |web2|

        web2.vm.box = "file://H:/Aaron/vagrant/centos73.box"
        
        web2.vm.hostname = "web2"
        
        web2.vm.network "forwarded_port", guest: 80, host: 1225
        
        web2.vm.synced_folder "H:/Aaron/vagrant/", "/home/vagrant", disabled: true

        web2.vm.synced_folder "H:/Aaron/vagrant/html", "/var/www/html", nfs: true, owner: "vagrant", group: "root"
        
        web2.vm.provider "virtualbox" do |vb|
            #vb.gui = true
            vb.memory = "2048"
        end
        
        web2.vm.provision "shell", :path => "provision.sh"
        
        # Create a private network, which allows host-only access to the machine
        # using a specific IP.
        web2.vm.network "private_network", ip: "77.77.77.2"
        #web2.vm.network "public_network", bridge: 'eth1', ip: "192.168.128.135"
    end 

    config.vm.define "web1" do |web1|

        web1.vm.box = "file://H:/Aaron/vagrant/centos73.box"
        
        web1.vm.hostname = "web1"
        
        web1.vm.network "forwarded_port", guest: 80, host: 1775
        
        web1.vm.synced_folder "H:/Aaron/vagrant/", "/vagrant", disabled: true

        web1.vm.synced_folder "H:/Aaron/vagrant/html", "/var/www/html/", nfs:true

        web1.vm.synced_folder "H:/Aaron/nodejs/", "/home/nodejs", nfs:true
        
        web1.vm.provider "virtualbox" do |vb|
            #vb.gui = true
            vb.memory = "2048"
        end
        
        web1.vm.provision "shell", :path => "provision-centos7.sh"
        
        # Create a private network, which allows host-only access to the machine
        # using a specific IP.
        web1.vm.network "private_network", ip: "77.77.77.2"
        #web1.vm.network "public_network", bridge: 'eth1', ip: "192.168.128.135"
    end
end