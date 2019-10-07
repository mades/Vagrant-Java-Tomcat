# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #config.vm.box = "ubuntu/trusty64"
  config.vm.box = "ubuntu/xenial64"


  # config.vm.box_check_update = false

  #config.vm.network "forwarded_port", guest: 80,  host: 8080
  #config.vm.network "forwarded_port", guest: 3306,  host: 33306
  config.vm.network "private_network", ip: "192.168.161.55"


  config.vm.synced_folder '../projects', '/var/www', nfs: true
  config.vm.synced_folder '.', '/var/env', nfs: true


  config.vm.provider "virtualbox" do |v|
    # Display the VirtualBox GUI when booting the machine
    v.gui = false

    v.customize ["modifyvm", :id, "--memory",               "1024"]
    v.customize ["modifyvm", :id, "--cpuexecutioncap",      "95"]
    #v.customize ["modifyvm", :id, "--natdnshostresolver1",  "on"]
    #v.customize ["modifyvm", :id, "--natdnsproxy1",         "on"]
    v.customize ["modifyvm", :id, "--cableconnected1",      "on"]
    v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate//var/www/", "1"]
  end

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.provision :shell, path: "provision_tomcat_java8.sh"

  config.trigger.after :up do |trigger|
    trigger.info = "Restarting tomcat..."
    trigger.run_remote = {inline: "/usr/local/apache-tomcat9/bin/startup.sh"}
  end

end
