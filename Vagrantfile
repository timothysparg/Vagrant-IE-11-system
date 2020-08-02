# -*- mode: ruby -*-
# vi: set ft=ruby :

$boxFile = "MSEdge - Win10.box"
$boxName = "groknull/EdgeOnWindows10"
$boxUrl = "https://az792536.vo.msecnd.net/vms/VMBuild_20190311/Vagrant/MSEdge/MSEdge.Win10.Vagrant.zip"
$machineName = "Windows-Browsers"
$zipFile = "MSEdge.Win10.Vagrant.zip"

Vagrant.configure("2") do |config|
  config.trigger.before :up do |trigger|
    trigger.name = "download Windows Browser box"
    trigger.ruby do |env, machine|
      provisionBox(env, machine,)
    end   
  end

  config.trigger.after :up do |trigger|
    retrieveIPAddress(trigger)  
  end

  config.vm.box = $boxName
  config.vm.box_version = "0.0.1"
  config.vm.guest = :windows
  config.vm.communicator = "winrm"
  config.vm.define $machineName
  config.vm.hostname = "win10"
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

  config.winrm.username = "IEUser"
  config.winrm.password = "Passw0rd!"
  config.winrm.retry_limit = 30
  config.winrm.retry_delay = 10

  config.vm.provider "virtualbox" do |v|
    v.gui = true
    v.memory = 4096
    v.cpus = 2  
    v.customize ["modifyvm", :id, "--vram", "64"]  
    v.customize ['modifyvm', :id, '--clipboard', 'bidirectional'] 
  end
end

def retrieveIPAddress(trigger)
  trigger.info = "Retrieve IP address"
  trigger.ruby do |env, machine|
    cmd = "Get-NetIPAddress  -InterfaceAlias 'Ethernet 2' | Select -ExpandProperty IPV4Address"
    machine.communicate.execute(cmd, { shell: :powershell }) do |type, data|
      ui = Vagrant::UI::Prefixed.new(env.ui, "")
      if type == :stderr
        ui.output(data)
      else
        ui.output(" 🖥   IP Address: #{data}")
      end
    end
  end  
end

def provisionBox(env, machine)
  ui = Vagrant::UI::Prefixed.new(env.ui, "")
  
  machineState = machine.state.short_description
  boxExists = (env.boxes.all.select{|box| box[0] == $boxName}).any?

  if machineState != 'not created'
    ui.output(" ✅ #{$machineName} machine exists, won't prompt to download Box")
  elsif boxExists
    ui.output(" ✅ #{$boxName} exists locally")
  else
    confirm = nil
    until ["Y", "y", "N", "n"].include?(confirm)
      ui.output(" ❓ No #{$boxName} box locally, would you like to install it? (Y/N) ")
      confirm = STDIN.gets.chomp
    end
    if confirm.upcase == "Y" 
      fetchBox(ui)
      unzipBox(ui)
      addBoxToLocalRegistry(ui, env, machine)
      cleanUpBox(ui)
      puts ' ⚡️ now let normal vagrant up processing begin'
    end
  end
end

def fetchBox(ui)
  # Start by downloading the file using the standard mechanism
  ui.output("🌐 downloading #{$boxName}")
  ui.detail("#{$boxUrl}")
  dl = Vagrant::Util::Downloader.new($boxUrl, $zipFile, ui: ui)
  dl.download!
end

def unzipBox(ui)
  ui.output(' 📦 unzipping box ')
  `unzip #{$zipFile}`
end

def addBoxToLocalRegistry(ui, env, machine)
  ui.output(' 🏠 adding box')
  box = env.boxes.add($boxFile , $boxName, "0.0.1", :metadata_url => "metadata.json")
  machine.box = box
end

def cleanUpBox(ui)
  ui.output(' 🛀 cleaning up')
  `rm #{$zipFile}`
  `rm -rf "#{$boxFile}"`
end