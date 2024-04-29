# kubevirt-vm

![Version: 0.2.5](https://img.shields.io/badge/Version-0.2.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

Configure a virtual machine for use with Kubevirt

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cloudymax | <emax@cloudydev.net> | <https://github.com/cloudymax/> |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cloudinit | object | `{"boot_cmd":[],"ca_certs":[],"disable_root":false,"groups":["docker","kvm"],"hostname":"scrapmetal","network":{"config":"disabled"},"package_update":true,"package_upgrade":false,"packages":["ssh-import-id"],"runcmd":["sudo -u friend -i ssh-import-id-gh cloudymax"],"users":[{"groups":"users, admin, sudo","lock_passwd":false,"name":"friend","passwd":"$6$rounds=4096$saltsaltlettuce$Lp/FV.2oOgew7GbM6Nr8KMGMBn7iFM0x9ZwLqtx9Y4QJmKvfcnS.2zx4MKmymCPQGpHS7gqYOiqWjvdCIV2uN.","shell":"/bin/bash","ssh_authorized_keys":[],"ssh_import_id":[],"sudo":"ALL=(ALL) NOPASSWD:ALL"}],"wireguard":[],"write_as_b64":false,"write_files":[{"apt-sources-list":null,"content":"apt-sources.list","path":"/etc/apt/sources.list","permissions":"0644"}]}` | Values used to generate a cloud-init user-data file Not all modules yet supported |
| cloudinit.boot_cmd | list | `[]` | Commands to run early in boot process |
| cloudinit.groups | list | `["docker","kvm"]` | Create Groups |
| cloudinit.hostname | string | `"scrapmetal"` | Set hostname of VM |
| cloudinit.package_update | bool | `true` | Update apt package cache |
| cloudinit.package_upgrade | bool | `false` | Perform apt package upgrade |
| cloudinit.packages | list | `["ssh-import-id"]` | apt packages to install |
| cloudinit.runcmd | list | `["sudo -u friend -i ssh-import-id-gh cloudymax"]` | commands to run in final step |
| cloudinit.users | list | `[{"groups":"users, admin, sudo","lock_passwd":false,"name":"friend","passwd":"$6$rounds=4096$saltsaltlettuce$Lp/FV.2oOgew7GbM6Nr8KMGMBn7iFM0x9ZwLqtx9Y4QJmKvfcnS.2zx4MKmymCPQGpHS7gqYOiqWjvdCIV2uN.","shell":"/bin/bash","ssh_authorized_keys":[],"ssh_import_id":[],"sudo":"ALL=(ALL) NOPASSWD:ALL"}]` | Create users |
| cloudinit.users[0].ssh_authorized_keys | list | `[]` | manually add a ssh public-key |
| cloudinit.users[0].ssh_import_id | list | `[]` | import ssh public-keys from github or lanchpad (doesnt work on Debian12) |
| cloudinit.wireguard | list | `[]` | provide a wireguard config |
| cloudinit.write_as_b64 | bool | `false` | base64 encode content of written files |
| cloudinit.write_files | list | `[{"apt-sources-list":null,"content":"apt-sources.list","path":"/etc/apt/sources.list","permissions":"0644"}]` | list of files to embed in the user-data |
| cloudinit.write_files[0].content | string | `"apt-sources.list"` | path to the source file for helm to read |
| cloudinit.write_files[0].path | string | `"/etc/apt/sources.list"` | Destination to write file on boot |
| cloudinit.write_files[0].permissions | string | `"0644"` | Permissions to assign the file |
| cloudinitEnabled | bool | `true` | enable or disable usage of cloud-init |
| cloudinitFromSecret | bool | `true` |  |
| cloudinitPath | string | `nil` | Provide a path to an existing cloud-init file will be genrated from values below if no file specified |
<<<<<<< HEAD
| disks | list | `[{"bootorder":1,"bus":"sata","name":"cloudinitvolume","pv-enable":false,"readonly":true,"type":"cdrom"},{"bootorder":2,"bus":"virtio","name":"harddrive","pvaccessMode":"ReadWriteOnce","pvsize":"8G","pvstorageClassName":"local-path","readonly":false,"source":"url","type":"disk","url":"https://cloud.debian.org/images/cloud/bookworm/daily/latest/debian-12-generic-amd64-daily.qcow2"}]` | List of disks to create for the VM, Will be used to create Datavolumes or PVCs. |
| disks[1].bootorder | int | `2` | Sets disk position in boot order, lower numbers are checked earlier |
| disks[1].bus | string | `"virtio"` | Bus type: sata or virtio |
| disks[1].pvaccessMode | string | `"ReadWriteOnce"` | Access mode for the PVC |
| disks[1].pvsize | string | `"8G"` | Size of disk in GB |
| disks[1].pvstorageClassName | string | `"local-path"` | Storage class to use for the pvc |
| disks[1].readonly | bool | `false` | Set disk to be Read-only |
| disks[1].source | string | `"url"` | source type of the disk image. One of `url`, `pvc` |
| disks[1].type | string | `"disk"` | Disk type: disk, cdrom, filesystem, or lun |
| disks[1].url | string | `"https://cloud.debian.org/images/cloud/bookworm/daily/latest/debian-12-generic-amd64-daily.qcow2"` | URL of cloud-image |
| service | list | `[{"externalTrafficPolicy":"Cluster","name":"service","ports":[{"name":"ssh","nodePort":30001,"port":22,"protocol":"TCP","targetPort":22},{"name":"vnc","nodePort":30005,"port":5900,"protocol":"TCP","targetPort":5900}],"type":"NodePort"}]` | Service objects are used to expose the VM to the outside world. Just like int he cloud each VM starts off isolated and will need to be exposed via a LoadBalancer, NodePort, or ClusterIp service. |
=======
| diskErrorPolicy | string | `"report"` | controls hypervisor behavior when IO errors occur on disk read or write. Possible values are: 'report', 'ignore', 'enospace' |
| disks | list | `[{"bootorder":1,"bus":"sata","name":"cloudinitvolume","pv-enable":false,"readonly":true,"type":"cdrom"},{"bootorder":2,"bus":"virtio","ephemeral":true,"name":"harddrive","pvc":"debian12","readonly":false,"type":"disk"}]` | List of disks to create for the VM, Will be used to create Datavolumes or PVCs. |
| service | list | `[{"externalTrafficPolicy":"Cluster","name":"vm0-service","ports":[{"name":"ssh","nodePort":30001,"port":22,"protocol":"TCP","targetPort":22},{"name":"vnc","nodePort":30005,"port":5900,"protocol":"TCP","targetPort":5900}],"type":"NodePort"}]` | Service objects are used to expose the VM to the outside world. Just like int he cloud each VM starts off isolated and will need to be exposed via a LoadBalancer, NodePort, or ClusterIp service. |
>>>>>>> 839c9ba (add support for disk error policy)
| virtualMachine.features.acpiEnabled | bool | `true` |  |
| virtualMachine.features.autoattachGraphicsDevice | bool | `true` | Attach a basic graphics device for VNC access |
| virtualMachine.features.autoattachPodInterface | bool | `true` | Make pod network interface the default for the VM |
| virtualMachine.features.autoattachSerialConsole | bool | `true` | Attach a serial console device  |
| virtualMachine.features.efiEnabled | bool | `true` | Enable EFI bios |
| virtualMachine.features.kvmEnabled | bool | `true` | Enable KVM acceleration |
| virtualMachine.features.secureBoot | bool | `false` | Enable Secure boot (Requires EFI) |
| virtualMachine.features.smmEnabled | bool | `true` |  |
| virtualMachine.gpus | list | `[]` | GPUs to pass to guest, requires that the GPUs are pre-configured in the  kubevirt custom resource. |
| virtualMachine.machine.cpuPassthrough | bool | `true` | Pass all CPU features and capabilities to Guest |
| virtualMachine.machine.hyperThreadingEnabled | bool | `false` | Enable the use of Hyperthreading on Intel CPUs. Disable on AMD CPUs. |
| virtualMachine.machine.machineType | string | `"q35"` | QEMU virtual-machine type |
| virtualMachine.machine.memory | string | `"8Gi"` | Amount of RAM to pass to the Guest |
| virtualMachine.machine.pinCores | bool | `false` | Pin QEMU process to specific physical cores Requires `--cpu-manager-policy` enabled in kubelet |
| virtualMachine.machine.vCores | int | `2` | Number of Virtual cores to pass to the Guest  |
| virtualMachine.name | string | `"vm0"` | name of the virtualMachine or virtualMachinePool object |
| virtualMachine.namespace | string | `"default"` | namespace to deploy |
| virtualMachine.runStrategy | string | `"RerunOnFailure"` | One of 'Always' `RerunOnFailure` `Manual` `Halted` |
| virtualMachinePool.enabled | bool | `false` |  |
| virtualMachinePool.size | int | `3` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
