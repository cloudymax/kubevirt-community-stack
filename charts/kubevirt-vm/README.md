# kubevirt-vm

![Version: 0.1.5](https://img.shields.io/badge/Version-0.1.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

Configure a virtual machine for use with Kubevirt

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cloudymax | <emax@cloudydev.net> | <https://github.com/cloudymax/> |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cloudinit | object | `{"boot_cmd":["apt-get update","apt-get install -y ssh-import-id"],"ca_certs":[],"disable_root":false,"groups":["docker","kvm"],"hostname":"scrapmetal","network":{"config":"disabled"},"package_update":true,"package_upgrade":true,"packages":[],"runcmd":[],"users":[{"groups":"users, admin, sudo","lock_passwd":false,"name":"friend","passwd":"$6$rounds=4096$saltsaltlettuce$Lp/FV.2oOgew7GbM6Nr8KMGMBn7iFM0x9ZwLqtx9Y4QJmKvfcnS.2zx4MKmymCPQGpHS7gqYOiqWjvdCIV2uN.","shell":"/bin/bash","ssh_authorized_keys":[],"ssh_import_id":[],"sudo":"ALL=(ALL) NOPASSWD:ALL"}],"wireguard":[],"write_as_b64":false,"write_files":{"apt-sources-list":{"content":"apt-sources.list","path":"/etc/apt/sources.list","permissions":"0644"}}}` | Values used to generate a cloud-init user-data file Not all modules yet supported |
| cloudinit.boot_cmd | list | `["apt-get update","apt-get install -y ssh-import-id"]` | Commands to run early in boot process |
| cloudinit.groups | list | `["docker","kvm"]` | Create Groups |
| cloudinit.hostname | string | `"scrapmetal"` | Set hostname of VM |
| cloudinit.package_update | bool | `true` | Update apt package cache |
| cloudinit.package_upgrade | bool | `true` | Perform apt package upgrade |
| cloudinit.packages | list | `[]` | apt packages to install |
| cloudinit.runcmd | list | `[]` | commands to run in final step |
| cloudinit.users | list | `[{"groups":"users, admin, sudo","lock_passwd":false,"name":"friend","passwd":"$6$rounds=4096$saltsaltlettuce$Lp/FV.2oOgew7GbM6Nr8KMGMBn7iFM0x9ZwLqtx9Y4QJmKvfcnS.2zx4MKmymCPQGpHS7gqYOiqWjvdCIV2uN.","shell":"/bin/bash","ssh_authorized_keys":[],"ssh_import_id":[],"sudo":"ALL=(ALL) NOPASSWD:ALL"}]` | Create users |
| cloudinit.users[0].ssh_authorized_keys | list | `[]` | manually add a ssh public-key |
| cloudinit.users[0].ssh_import_id | list | `[]` | import ssh public-keys from github or lanchpad doesnt work on Debian12 |
| cloudinit.wireguard | list | `[]` | provide a wireguard config |
| cloudinit.write_as_b64 | bool | `false` | base64 encode content of written files |
| cloudinit.write_files | object | `{"apt-sources-list":{"content":"apt-sources.list","path":"/etc/apt/sources.list","permissions":"0644"}}` | list of files to embed in the user-data |
| cloudinit.write_files.apt-sources-list.content | string | `"apt-sources.list"` | path to the source file for helm to read |
| cloudinit.write_files.apt-sources-list.path | string | `"/etc/apt/sources.list"` | Destination to write file on boot |
| cloudinit.write_files.apt-sources-list.permissions | string | `"0644"` | Permissions to assign the file |
| cloudinitPath | string | `nil` | Provide a path to an existing cloud-init file will be genrated from values below if no file specified |
| disks | list | `[{"bootorder":2,"bus":"virtio","name":"harddrive","pvaccessMode":"ReadWriteOnce","pvsize":"32G","pvstorageClass":"local-path","readonly":false,"source":"https://cloud.debian.org/images/cloud/bookworm/daily/latest/debian-12-generic-amd64-daily.qcow2","type":"disk"},{"bootorder":1,"bus":"sata","name":"cloudinitvolume","pv-enable":false,"readonly":true,"type":"cdrom"}]` | List of disks to create for the VM. Will be used to create a Datavolume. |
| disks[0] | object | `{"bootorder":2,"bus":"virtio","name":"harddrive","pvaccessMode":"ReadWriteOnce","pvsize":"32G","pvstorageClass":"local-path","readonly":false,"source":"https://cloud.debian.org/images/cloud/bookworm/daily/latest/debian-12-generic-amd64-daily.qcow2","type":"disk"}` | Disk Name |
| disks[0].bootorder | int | `2` | Sets disk position in boot order, lower numbers are checked earlier |
| disks[0].bus | string | `"virtio"` | Bus type: sata or virtio |
| disks[0].pvaccessMode | string | `"ReadWriteOnce"` | Access mode for the PVC |
| disks[0].pvsize | string | `"32G"` | Size of disk in GB |
| disks[0].pvstorageClass | string | `"local-path"` | Storage class to use for the pvc |
| disks[0].readonly | bool | `false` | Set disk to be Read-only |
| disks[0].source | string | `"https://cloud.debian.org/images/cloud/bookworm/daily/latest/debian-12-generic-amd64-daily.qcow2"` | URL of cloud-image |
| disks[0].type | string | `"disk"` | Disk type: disk, cdrom, filesystem, or lun |
| disks[1] | object | `{"bootorder":1,"bus":"sata","name":"cloudinitvolume","pv-enable":false,"readonly":true,"type":"cdrom"}` | cloud-init volume which holds your user-data file.  Required to be first boot option |
| iso.bootFromIso | bool | `false` |  |
| iso.isoImage | string | `"https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/debian-12.0.0-amd64-DVD-1.iso"` |  |
| service | list | `[]` | Service objects are used to expose the VM to the outside world. Just like int he cloud each VM starts off isolated and will need to be exposed via a LoadBalancer, NodePort, or ClusterIp service. |
| virtualMachine.features | object | `{"acpiEnabled":true,"autoattachGraphicsDevice":true,"autoattachPodInterface":true,"autoattachSerialConsole":true,"efiEnabled":true,"kvmEnabled":true,"smmEnabled":true}` | Enable vm features |
| virtualMachine.machine.cpuPassthrough | bool | `false` | Pass all CPU features and capabilities to Guest |
| virtualMachine.machine.hyperThreadingEnabled | bool | `false` | Enable the use of Hyperthreading on Intel CPUs. Disable on AMD CPUs. |
| virtualMachine.machine.machineType | string | `"q35"` | QEMU virtual-machine type |
| virtualMachine.machine.memory | string | `"4Gi"` | Amount of RAM to pass the the Guest |
| virtualMachine.machine.pinCores | bool | `false` | Pin QEMU process to specific physical cores Requires `--cpu-manager-policy` enabled in kubelet |
| virtualMachine.machine.vCores | int | `2` | Number of Virtual cores to pass to the Guest  |
| virtualMachine.name | string | `"vm0"` | name of the virtualMachine object |
| virtualMachine.namespace | string | `"vm0"` | namespace to deploy the vm |
| virtualMachine.runStrategy | string | `"RerunOnFailure"` | One of 'Always' `RerunOnFailure` `Manual` `Halted` |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
