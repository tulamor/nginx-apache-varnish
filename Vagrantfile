# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "centos/7"
  config.vm.host_name = "assessment"

  config.vm.network "forwarded_port", guest: 81, host: 8081 # nginx
  config.vm.network "forwarded_port", guest: 82, host: 8082 # apache
  config.vm.network "private_network", ip: "192.168.100.101"

  config.vm.provision "shell", path: "./install.sh"
  
end
