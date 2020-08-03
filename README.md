### Vagrant IE 11 system

A Window system with Chrome, Firefox, Edge (legacy) and IE11 installed on it.

On boot this machine auto logins in and starts a selenium server running on port 4444.

The IP address of the guest machine is shown at the end of the `vagrant up` command or can be retrieved with the following
```shell
 vagrant winrm -c "Get-NetIPAddress  -InterfaceAlias 'Ethernet 2' | Select -ExpandProperty IPV4Address"
```
## Setup steps
1. install vagrant
    ```shell
    $> brew install vagrant
    ```

1. call vagrant
    ```shell
    $> vagrant up
    ```

1. Get some coffee. There's a lot going on here and it will take some time for this complete.
    - Downloads the box
    - Unzips the box
    - Adds the box to the local Vagrant registry
    - Creates your VM
        - WinRM (the tool that vagrant uses to communicate with Windows) is slow to initialise; it depends on other windows services, so it will be the last to start - have another coffee
    - Starts installing all the software we need
    - Will reboot the guest several times
    - The system will show the desktop while it is still initialising, this might take some time; Thanks WinRM.
    - This whole process could take up to 40 minutes
        - highly dependant on download speeds

1. Note the IP address provided at the end of the script, it might be of interest to you

1. After the initial provision and boot, `vagrant up` will be much faster (about 3 mins). 

1. To shutdown call
    ```shell
    $> vagrant halt
    ```

## Notes
- The MS vagrant box does not include a `metadata.json` file, so in order to make this a one step process, we do some hacky stuff as part of the vagrant up
- If you're going to leave your laptop unattended beware that it will hibernate; `caffeinate -i` is a simple solution for this