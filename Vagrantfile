# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'open3'

Vagrant.configure("2") do |config|
  config.trigger.before :up do |trigger|
    trigger.name = "download IE11 Windows box"
   
    boxes = Open3.capture3("vagrant box list")
    # if the zip file exists, we're most probably working on adding it
    zipFile = system('ls MSEdge.Win10.Vagrant.zip')

    if !boxes.include? "groknull/EdgeOnWindows10" and !zipFile 
      `wget https://az792536.vo.msecnd.net/vms/VMBuild_20190311/Vagrant/MSEdge/MSEdge.Win10.Vagrant.zip`
      puts '📦 unzipping box '
      `unzip MSEdge.Win10.Vagrant.zip`
      puts '🏠 adding box'
      `vagrant box add --name groknull/EdgeOnWindows10 'MSEdge - Win10.box'`
      puts '🧹 cleaning up'
      `rm MSEdge.Win10.Vagrant.zip`
      `rm -rf 'MSEdge - Win10.box'`
      puts '👍'
      puts 'and now let normal vagrant up processing begin...'
    end
  end

  config.vm.box = "groknull/EdgeOnWindows10"
  # config.vm.box_url = "./metadata.json"
  config.vm.guest = :windows
  config.vm.communicator = "winrm"
  config.vm.define "Windows-Browsers"
  config.vm.hostname = "win10"
  # config.vm.hostname = "win10.test"
  config.vm.network "private_network", type: "dhcp", :name => 'vboxnet2', :adapter => 2
  config.vm.network "forwarded_port", guest: 3389, host: 3389
  config.vm.network "forwarded_port", guest: 4444, host: 4444
  config.vbguest.auto_update = false
  
  config.vm.provision "shell", path: "scripts/initialize-vm.ps1"
  config.vm.provision "shell", path: "scripts/choco-cinst.ps1"
  config.vm.provision "shell", path: "scripts/install-iedriverserver-win32.ps1" 
  config.vm.provision "shell", path: "scripts/enable-edge-webdriver.ps1"
  config.vm.provision "shell", path: "scripts/selenium-startup.ps1"
  # restart to allow selenium to start in the user session 
  # and for whatever other windows things that need it
  config.vm.provision "shell", path: "scripts/autologon.ps1", reboot: true
  # config.vm.provision "shell", path: "scripts/setResolution.ps1", powershell_elevated_interactive: true

  # config.winrm.host = 'win10.test'
  # config.winrm.port = '55985' 
  config.winrm.username = "IEUser"
  config.winrm.password = "Passw0rd!"

  config.vm.provider "virtualbox" do |v|
    v.gui = true
    v.memory = 4096
    v.cpus = 2  
    v.customize ["modifyvm", :id, "--vram", "64"]  
    v.customize ['modifyvm', :id, '--clipboard', 'bidirectional'] 
  end
end
