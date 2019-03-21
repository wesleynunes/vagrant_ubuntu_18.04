# Vagrantfile para ubuntu 18.04 bionic
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.hostname = "bionic"
  config.vm.network :private_network, ip: "192.168.33.50"
  config.vm.synced_folder("./", "/var/www/html", :nfs => true)
  config.vm.provider "virtualbox" do |machine|
    machine.memory = 1024
    machine.cpus = 1
    machine.name = "bionic"
  end
  config.vm.provision :shell, path: "setup.sh" 
end
