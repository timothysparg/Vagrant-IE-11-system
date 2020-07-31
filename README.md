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
2. call vagrant
    ```shell
    $> vagrant up
    ```
## Notes
- The MS vagrant box does not include a `metadata.json` file, so in order to make this a one step process, we do some hacky stuff as part of the vagrant up