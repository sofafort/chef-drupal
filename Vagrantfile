Vagrant.configure("2") do |config|
  BOX = ENV.fetch('BOX', 'ubuntu-14.04')


  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://proxy.austin.hp.com:8080/"
    config.proxy.https    = "http://proxy.austin.hp.com:8080/"
    config.proxy.no_proxy = "localhost,127.0.0.1"
  end

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "drupal"
  end

  config.vm.network "forwarded_port", guest: 80, host: 1800

  config.vm.box = BOX
  if BOX == 'ubuntu-14.04'
    config.vm.box_url = 'https://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box'
  end
end
