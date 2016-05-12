# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.configure(2) do |config|
	# The most common configuration options are documented and commented below.
	# For a complete reference, please see the online documentation at
	# https://docs.vagrantup.com.

	# Every Vagrant development environment requires a box. You can search for
	# boxes at https://atlas.hashicorp.com/search.
	config.vm.box = "develop"

	# Disable automatic box update checking. If you disable this, then
	# boxes will only be checked for updates when the user runs
	# `vagrant box outdated`. This is not recommended.
	# config.vm.box_check_update = false

	# Create a forwarded port mapping which allows access to a specific port
	# within the machine from a port on the host machine. In the example below,
	# accessing "localhost:8080" will access port 80 on the guest machine.
	config.vm.network "forwarded_port", guest: 3000, host: 3000
	config.vm.network "forwarded_port", guest: 4000, host: 4000

	# Create a private network, which allows host-only access to the machine
	# using a specific IP.
	config.vm.network "private_network", ip: "192.168.33.10"

	# Create a public network, which generally matched to bridged network.
	# Bridged networks make the machine appear as another physical device on
	# your network.
	config.vm.network "public_network"

	# Share an additional folder to the guest VM. The first argument is
	# the path on the host to the actual folder. The second argument is
	# the path on the guest to mount the folder. And the optional third
	# argument is a set of non-required options.
	config.vm.synced_folder "../workspace", "/vagrant/workspace"

	# Provider-specific configuration so you can fine-tune various
	# backing providers for Vagrant. These expose provider-specific options.
	# Example for VirtualBox:
	#
	config.vm.provider "virtualbox" do |vb|
		vb.name = "dev"
		 # Display the VirtualBox GUI when booting the machine
		#  vb.gui = true

		 # Customize the amount of memory on the VM:
		#  vb.memory = "1024"
	end
	#
	# View the documentation for the provider you are using for more
	# information on available options.

	# Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
	# such as FTP and Heroku are also available. See the documentation at
	# https://docs.vagrantup.com/v2/push/atlas.html for more information.
	# config.push.define "atlas" do |push|
	#	 push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
	# end

	# Enable provisioning with a shell script. Additional provisioners such as
	# Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
	# documentation for more information about their specific syntax and use.
	config.vm.provision "fix-no-tty", type: "shell" do |s|
		s.privileged = false
		s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
	end

	config.vm.provision "shell", inline: <<-SHELL
		sudo echo "export LANGUAGE=en_US.UTF-8" >> /etc/profile
		sudo echo "export LANG=en_US.UTF-8" >> /etc/profile
		sudo echo "export LC_ALL=en_US.UTF-8" >> /etc/profile
	SHELL

	config.vm.provision "shell", inline: <<-SHELL
		sudo chown vagrant /etc/apt/sources.list
		sudo chgrp vagrant /etc/apt/sources.list
		sudo cp /etc/apt/sources.list /etc/apt/sources.list_bak
	SHELL

	config.vm.provision "file", source: "sources.list", destination: "/etc/apt/sources.list"
	config.vm.provision "file", source: "node-v5.10.1-linux-x64.tar.xz", destination: "/home/vagrant/node-v5.10.1-linux-x64.tar.xz"

	config.vm.provision "shell", inline: <<-SHELL
		sudo locale-gen en_US.UTF-8
		sudo dpkg-reconfigure locales
		sudo apt-get update
		sudo apt-get install -y git xz-utils wget memcached redis-server curl make gcc build-essential python2.7
	SHELL

	config.vm.provision "shell", inline: <<-SHELL
		sudo mkdir conf
		sudo mkdir pid
		sudo mkdir log
		sudo mkdir bash
		sudo chown vagrant *
		sudo chgrp vagrant *

		# sudo wget --tries=100 --retry-connrefused https://nodejs.org/dist/v5.10.1/node-v5.10.1-linux-x64.tar.xz
		sudo xz -d node-v5.10.1-linux-x64.tar.xz
		sudo tar -xvf node-v5.10.1-linux-x64.tar
		sudo rm node-v5.10.1-linux-x64.tar
		sudo mv node-v5.10.1-linux-x64 /usr/local/node
		sudo chmod 755 /usr/local/node/* -R
		sudo ln -s /usr/local/node/bin/node /usr/bin/node
		sudo ln -s /usr/local/node/bin/npm /usr/bin/npm
		sudo npm install coffee-script -g
		sudo ln -s /usr/local/node/lib/node_modules/coffee-script/bin/coffee /usr/bin/coffee
		sudo ln -s /usr/local/node/lib/node_modules/coffee-script/bin/cake /usr/bin/cake

		sudo cp /etc/redis/redis.conf /home/vagrant/conf
		sudo sed -i s#\/var\/run\/redis\/redis-server.pid#\/home\/vagrant\/pid\/redis-server.pid#g /home/vagrant/conf/redis.conf
		sudo sed -i s#\/var\/log\/redis\/redis-server.log#\/home\/vagrant\/log\/redis-server.log#g /home/vagrant/conf/redis.conf

		sudo pkill -f memcached
		memcached -d -u vagrant -P /home/vagrant/pid/memcached.pid
		sudo pkill -f redis-server
		redis-server /home/vagrant/conf/redis.conf
	SHELL

	# config.push.define "local-exec" do |push|
	#	 push.script = "bash.sh"
	# end
end
