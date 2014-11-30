# -*- mode: ruby -*-
# # vi: set ft=ruby :
#
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.hostname = "opennebula-precise64"
  config.vm.provision "shell", path: "postinstall.sh"
  config.vm.network :forwarded_port, guest: 9869 , host: 9869
end
