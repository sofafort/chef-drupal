Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise64"

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
end
