# cloud-init

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart that generates cloud-init config files

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cloudymax |  |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argocd.appName | string | `"none"` | ArgoCD App name for optional resource tracking |
| argocd.compare | string | `"IgnoreExtraneous"` | String containing ArgoCD comparison options |
| argocd.enabled | bool | `true` |  |
| argocd.syncString | string | `"Prune=false,Delete=false"` | String containing ArgoCD resource sync options |
| boot_cmd | list | `[]` | Run arbitrary commands early in the boot process See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#bootcmd |
| ca_certs | list | `[]` | Add CA certificates See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#ca-certificates |
| debug | bool | `false` | when enabled job sleeps to allow user to exec into the container |
| disable_root | bool | `false` | Disable root login over ssh |
| disk_setup | list | `[]` |  |
| envsubst | bool | `true` | Run envsubst against user-data in the templated configmap during job run. Not an official part of cloid-init |
| existingConfigMap | bool | `false` | Dont recreate script configmap. Set to true when keeping multiple cloud-init secrets in the same namespace |
| extraEnvVars | list | `[{"name":"USERNAME","value":"friend"},{"name":"macaddress","value":"b8:a3:86:70:cc:e6"}]` | Set extra environment variables for the job container |
| force | bool | `true` | overwrite any existing secrets matching `secret_name` |
| fs_setup | list | `[]` |  |
| hostname | string | `"random"` | virtual-machine hostname. When set to 'random' a hostname will be generated using golang-petname. |
| image | string | `"deserializeme/kv-cloud-init:1.0.0"` | image version |
| mounts | list | `[]` | Set up mount points. mounts contains a list of lists. The inner list contains entries for an /etc/fstab line |
| namespace | string | `"default"` | namespace in which to create resources |
| network | object | `{"config":"disabled"}` | networking options |
| network.config | string | `"disabled"` | disable cloud-init’s network configuration capability and rely on other methods such as embedded configuration or other customisations. |
| networkData.content | string | `"renderer: networkd\nnetwork:\n  version: 2\n  ethernets:\n    multus:\n      match:\n        macaddress: ${macaddress}\n      dhcp4: false\n      dhcp6: false\n      addresses:\n        - 192.168.100.100/24\n      routes:\n        - to: default\n          via: 192.168.100.1\n      mtu: 1500\n      nameservers:\n        addresses:\n          - 192.168.100.1"` |  |
| networkData.enabled | bool | `false` |  |
| package_reboot_if_required | bool | `false` | Update, upgrade, and install package See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#package-update-upgrade-install |
| package_update | bool | `true` |  |
| package_upgrade | bool | `false` |  |
| packages | list | `[]` |  |
| runcmd | list | `[]` | Run arbitrary commands See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#runcmd |
| salt | string | `"saltsaltlettuce"` | salt used for password generation |
| secret_name | string | `"my-userdata"` | secret in which to save the user-data file, must be unique within namespace |
| serviceAccount | object | `{"create":true,"existingServiceAccountName":"some-other-sa","name":"my-service-account"}` | Choose weather to create a service-account or not. Once a SA has been created you should set this to false on subsequent runs, or use a uniqne name per vm. |
| swap | object | `{"enabled":false,"filename":"/swapfile","maxsize":"1G","size":"1G"}` | creates a swap file using human-readable values. |
| users | list | `[{"groups":"users, admin, docker, sudo, kvm","lock_passwd":false,"name":"$USERNAME","password":"random","shell":"/bin/bash","ssh_authorized_keys":[],"ssh_import_id":[],"sudo":"ALL=(ALL) NOPASSWD:ALL"}]` | user configuration options See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#users-and-groups do NOT use 'admin' as username - it conflicts with multiele cloud-images |
| users[0].password | string | `"random"` | set user password from existing secret or generate random When set to 'random' a password will be generated for the user. |
| users[0].ssh_authorized_keys | list | `[]` | provider user ssh pub key as plaintext |
| users[0].ssh_import_id | list | `[]` | import user ssh public keys from github, gitlab, or launchpad See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#ssh |
| wireguard | list | `[]` | add wireguard configuration from existing secret or as plain-text See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#wireguard |
| write_files | list | `[]` | Write arbitrary files to disk. Files my be provided as plain-text or downloaded from a url See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#write-files |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
