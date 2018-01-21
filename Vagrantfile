# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "puppetlabs/centos-7.2-64-nocm"
  config.vm.provision "shell", path: "vagrant/provision.sh", privileged: false
end
