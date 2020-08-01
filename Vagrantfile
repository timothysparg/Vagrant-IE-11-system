# -*- mode: ruby -*-
# vi: set ft=ruby :
winBoxUrl = "https://az792536.vo.msecnd.net/vms/VMBuild_20190311/Vagrant/MSEdge/MSEdge.Win10.Vagrant.zip"
zipFileName = "MSEdge.Win10.Vagrant.zip"
boxName = "groknull/EdgeOnWindows10"
boxFilename = "MSEdge - Win10.box"

Vagrant.configure("2") do |config|
  config.trigger.before :up do |trigger|
    trigger.name = "download IE11 Windows box"
    trigger.ruby do |env,machine|
      boxExists = (env.boxes.all.select{|box| box[0] == boxName}).any?
      confirm = nil
      if !boxExists
        until ["Y", "y", "N", "n"].include?(confirm)
          puts "❓ No EdgeOnWindows10 box locally, would you like to install it? (Y/N) "
          confirm = STDIN.gets.chomp
        end
        if confirm.upcase == "Y" 
          # Prefixed UI for prettiness
          ui = Vagrant::UI::Prefixed.new(env.ui, "")

          # Start by downloading the file using the standard mechanism
          ui.output("🌐 downloading #{boxName}")
          ui.detail("#{winBoxUrl}")
          dl = Vagrant::Util::Downloader.new(winBoxUrl, zipFileName, ui: ui)
          dl.download!
          puts '📦 unzipping box '
          `unzip #{zipFileName}`
          puts '🏠 adding box'
          box = env.boxes.add(boxFilename, boxName, "0.0.1", :metadata_url => "metadata.json")
          machine.box = box
          puts '🛀 cleaning up'
          `rm #{zipFileName}`
          `rm -rf "#{boxFilename}"`
          puts '⚡️ now let normal vagrant up processing begin'
        end
      end
    end   
  end

  config.trigger.after :up do |trigger|
    trigger.info = "Retrieve IP address"
    trigger.ruby do |env,machine|
      ipAddress = `vagrant winrm -c "Get-NetIPAddress  -InterfaceAlias 'Ethernet 2' | Select -ExpandProperty IPV4Address"`
      puts '🖥 IP Address: #{ipAddress}'
    end    
  end

  config.vm.box = "groknull/EdgeOnWindows10"
  config.vm.box_version = "0.0.1"
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
