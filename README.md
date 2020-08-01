### Vagrant IE 11 system

A Window system with Chrome, Firefox, Edge (legacy) and IE11 installed on it.

On boot this machine auto logins in and starts a selenium server running on port 4444.

The Ip address of the guest machine can be found retrieved with the following command
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
    - WinRM seems pretty slow to initialise on VM reboots, have another coffee
    - Starts installing all the software we need
    - When the  system has finished initialising it will login and selenium will be running in the  foreground

1. Note the IP address provided at the end of the script, it might be of interest to you

## Notes
- The MS vagrant box does not include a `metadata.json` file, so in order to make this a one step process, we do some hacky stuff as part of the vagrant up