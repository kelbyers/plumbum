# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.provision "shell", path: "vagrant/provision-ubuntu.sh", privileged: false
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
  end
  # config.vm.box = "puppetlabs/centos-7.2-64-nocm"
  # config.vm.provision "shell", path: "vagrant/provision.sh", privileged: false
end
