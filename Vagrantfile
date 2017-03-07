# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.

  if Vagrant.has_plugin?("vagrant-env")
    config.env.enable
  end

  config.vm.define "streaming" do |streaming|
    streaming.vm.network "private_network", ip: "192.168.33.10"
    streaming.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "ansible/streaming.yml"
      ansible.install  = true
    end
  end

  config.vm.define "uploader" do |uploader|
    uploader.vm.network "private_network", ip: "192.168.33.20"
    uploader.vm.synced_folder "html", "/var/html"
    uploader.vm.synced_folder "video_uploader", "/srv/apps/video_uploader"
    uploader.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "ansible/uploader.yml"
      ansible.install  = true
    end
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb, override|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true
    override.vm.box = 'ubuntu/xenial64'
  
    # Customize the amount of memory on the VM:
    vb.memory = "4096"

    if Vagrant.has_plugin?("vagrant-cachier")
      override.cache.scope = :box
      override.cache.synced_folder_opts = {
        type: :nfs,
        mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
      }
    end
  end

  config.vm.provider :linode do |provider, override|
    override.ssh.username = 'esgadmin'
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.vm.box = 'linode/ubuntu1404'

    provider.api_key = ENV['LINODE_API_TOKEN']
    provider.distribution = 'Ubuntu 16.04 LTS'
    provider.datacenter = 'singapore'
    provider.plan = 'Linode 4096'
    provider.label = 'esg-video-uploader'
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.

  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   sudo apt-get install -y python
  # SHELL
end
