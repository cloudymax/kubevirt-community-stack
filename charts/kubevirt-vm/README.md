# kubevirt-vm

![Version: 0.4.5](https://img.shields.io/badge/Version-0.4.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

Configure a virtual machine for use with Kubevirt

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cloudymax | <emax@cloudydev.net> | <https://github.com/cloudymax/> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://cloudymax.github.io/kubevirt-community-stack | cloudinit(cloud-init) | 0.2.6 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cloudinit | object | `{"boot_cmd":[],"ca_certs":[],"debug":false,"disable_root":false,"enabled":true,"envsubst":false,"existingConfigMap":true,"extraEnvVars":[],"hostname":"test","image":"deserializeme/kv-cloud-init:v0.0.1","namespace":"kubevirt","network":{"config":"disabled"},"package_reboot_if_required":false,"package_update":false,"package_upgrade":false,"packages":[],"runcmd":[],"salt":"saltsaltlettuce","secret_name":"test-scrapmetal-user-data","serviceAccount":{"create":false,"existingServiceAccountName":"cloud-init-sa","name":"cloud-init-sa"},"users":[{"groups":"users, admin, docker, sudo, kvm","lock_passwd":false,"name":"test","password":{"random":true},"shell":"/bin/bash","ssh_authorized_keys":[],"ssh_import_id":[],"sudo":"ALL=(ALL) NOPASSWD:ALL"}],"wireguard":[],"write_files":[]}` | Enable or disable usage of cloud-init sub-chart |
| cloudinit.boot_cmd | list | `[]` | Run arbitrary commands early in the boot process See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#bootcmd |
| cloudinit.ca_certs | list | `[]` | Add CA certificates See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#ca-certificates |
| cloudinit.debug | bool | `false` | when enabled job sleeps to allow user to exec into the container |
| cloudinit.disable_root | bool | `false` | Disable root login over ssh |
| cloudinit.envsubst | bool | `false` | Run envsubst against bootcmd and runcmd fields at the beginning of templating Not an official part of cloid-init |
| cloudinit.existingConfigMap | bool | `true` | Dont recreate script configmap. Set to true when keeping multiple cloud-init secrets in the same namespace |
| cloudinit.hostname | string | `"test"` | virtual-machine hostname |
| cloudinit.image | string | `"deserializeme/kv-cloud-init:v0.0.1"` | image version |
| cloudinit.namespace | string | `"kubevirt"` | namespace in which to create resources |
| cloudinit.network | object | `{"config":"disabled"}` | networking options |
| cloudinit.network.config | string | `"disabled"` | disable cloud-init’s network configuration capability and rely on other methods such as embedded configuration or other customisations. |
| cloudinit.package_reboot_if_required | bool | `false` | Update, upgrade, and install packages See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#package-update-upgrade-install |
| cloudinit.runcmd | list | `[]` | Run arbitrary commands See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#runcmd |
| cloudinit.salt | string | `"saltsaltlettuce"` | salt used for password generation |
| cloudinit.secret_name | string | `"test-scrapmetal-user-data"` | name of secret in which to save the user-data file |
| cloudinit.serviceAccount | object | `{"create":false,"existingServiceAccountName":"cloud-init-sa","name":"cloud-init-sa"}` | Choose weather to create a service-account or not. Once a SA has been created you should set this to false on subsequent runs. |
| cloudinit.users | list | `[{"groups":"users, admin, docker, sudo, kvm","lock_passwd":false,"name":"test","password":{"random":true},"shell":"/bin/bash","ssh_authorized_keys":[],"ssh_import_id":[],"sudo":"ALL=(ALL) NOPASSWD:ALL"}]` | user configuration options See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#users-and-groups do NOT use 'admin' as username - it conflicts with multiele cloud-images |
| cloudinit.users[0].password | object | `{"random":true}` | set user password from existing secret or generate random |
| cloudinit.users[0].ssh_authorized_keys | list | `[]` | provider user ssh pub key as plaintext |
| cloudinit.users[0].ssh_import_id | list | `[]` | import user ssh public keys from github, gitlab, or launchpad See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#ssh |
| cloudinit.wireguard | list | `[]` | add wireguard configuration from existing secret or as plain-text See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#wireguard |
| cloudinit.write_files | list | `[]` | Write arbitrary files to disk. Files my be provided as plain-text or downloaded from a url See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#write-files |
| diskErrorPolicy | string | `"report"` | controls hypervisor behavior when I/O errors occur on disk read or write. Possible values are: 'report', 'ignore', 'enospace' |
| disks | list | `[{"bootorder":2,"bus":"virtio","name":"harddrive","pvaccessMode":"ReadWriteOnce","pvsize":"16Gi","pvstorageClass":"fast-raid","readonly":false,"source":"url","type":"disk","url":"https://buildstars.online/debian-12-generic-amd64-daily.qcow2"}]` | List of disks to create for the VM, Will be used to create Datavolumes or PVCs. |
| disks[0].bootorder | int | `2` | Sets disk position in boot order, lower numbers are checked earlier |
| disks[0].bus | string | `"virtio"` | Bus type: sata or virtio |
| disks[0].pvaccessMode | string | `"ReadWriteOnce"` | Access mode for the PVC |
| disks[0].pvsize | string | `"16Gi"` | Size of disk in GB |
| disks[0].pvstorageClass | string | `"fast-raid"` | Storage class to use for the pvc |
| disks[0].readonly | bool | `false` | Set disk to be Read-only |
| disks[0].source | string | `"url"` | source type of the disk image. One of `url`, `pvc` |
| disks[0].type | string | `"disk"` | Disk type: disk, cdrom, filesystem, or lun |
| disks[0].url | string | `"https://buildstars.online/debian-12-generic-amd64-daily.qcow2"` | URL of cloud-image |
| service | list | `[{"externalTrafficPolicy":"Cluster","name":"service","ports":[{"name":"ssh","port":22,"protocol":"TCP","targetPort":22},{"name":"vnc","port":5900,"protocol":"TCP","targetPort":5900}],"type":"NodePort"}]` | Service cinfiguration. Used to expose VM to the outside world. Accepts a list of ports to open. |
| userDataSecret | object | `{"enabled":false,"name":""}` | Use an existing cloud-init userdata secret ignored if cloudinit subchart is enabled. |
| virtualMachine.clock | object | `{"enabled":true,"hpet":{"enabled":true,"present":false},"hyperv":false,"kvm":true,"pit":{"enabled":true,"tickPolicy":"delay"},"rtc":{"enabled":true,"tickPolicy":"catchup"},"timezone":"utc"}` | Options for machine clock |
| virtualMachine.clock.hpet | object | `{"enabled":true,"present":false}` | High Precision Event Timer |
| virtualMachine.clock.hyperv | bool | `false` | Hyper-V's reference time counter for use with Windows guests. |
| virtualMachine.clock.kvm | bool | `true` | Paravirtualized clock that provides better accuracy and performance. Recommended clock source for KVM guest virtual machines. |
| virtualMachine.clock.pit | object | `{"enabled":true,"tickPolicy":"delay"}` | Programmable interval timer |
| virtualMachine.clock.rtc | object | `{"enabled":true,"tickPolicy":"catchup"}` | Real-Time Clock |
| virtualMachine.clock.timezone | string | `"utc"` | Set clock timezone eg: "Europe/Amsterdam" or "utc" |
| virtualMachine.features.acpiEnabled | bool | `true` |  |
| virtualMachine.features.autoattachGraphicsDevice | bool | `true` | Attach a basic graphics device for VNC access |
| virtualMachine.features.autoattachPodInterface | bool | `true` | Make pod network interface the default for the VM |
| virtualMachine.features.autoattachSerialConsole | bool | `true` | Attach a serial console device |
| virtualMachine.features.hyperv | bool | `false` |  |
| virtualMachine.features.kvm | object | `{"enabled":true,"hidden":true}` | Enable KVM acceleration |
| virtualMachine.features.networkInterfaceMultiqueue | bool | `true` | Enhances network performance by allowing multiple TX and RX queues. |
| virtualMachine.firmware.efi | object | `{"enabled":true,"secureBoot":false}` | Enable EFI bios and secureboot |
| virtualMachine.firmware.smmEnabled | bool | `false` |  |
| virtualMachine.firmware.uuid | string | `"5d307ca9-b3ef-428c-8861-06e72d69f223"` |  |
| virtualMachine.gpus | list | `[]` | GPUs to pass to guest, requires that the GPUs are pre-configured in the kubevirt custom resource. ignored when instancetype is defined. ramFB & display may only be enabled on 1 vGPU |
| virtualMachine.interfaces | list | `[{"masquerade":{},"model":"virtio","name":"default"}]` | virtual network interface config options. See: https://kubevirt.io/user-guide/network/interfaces_and_networks/#interfaces |
| virtualMachine.interfaces[0] | object | `{"masquerade":{},"model":"virtio","name":"default"}` | bridge mode, vms are connected to the network via a linux "bridge". Pod network IP is delegated to vm via DHCPv4. VM must use DHCP for an IP |
| virtualMachine.machine.architecture | string | `"amd64"` | Arch |
| virtualMachine.machine.cpuModel | string | `"host-passthrough"` | Specify hots-passthrough or a named cpu model https://www.qemu.org/docs/master/system/qemu-cpu-models.html |
| virtualMachine.machine.hyperThreadingEnabled | bool | `true` | Enable the use of Hyperthreading on Intel CPUs. Disable on AMD CPUs. |
| virtualMachine.machine.instancetype | object | `{"enabled":false,"kind":"virtualMachineClusterInstancetype","name":"standard-small"}` | Define CPU, RAM, GPU, HostDevice settings for VMs. Overrides: vCores, memory, gpus |
| virtualMachine.machine.machineType | string | `"q35"` | QEMU virtual-machine type |
| virtualMachine.machine.memory | object | `{"base":"4Gi","overcommit":{"enabled":false,"limit":"8Gi","overhead":false}}` | Amount of RAM to pass to the Guest. Ignored when instancetype is defined |
| virtualMachine.machine.memory.overcommit.enabled | bool | `false` | Enable memory overcommitment. Tells VM it has more RAM than requested. VMI becomes Burtable QOS class and may be preempted when node is under memory pressure. GPU passthrough and vGPU will not function with overcommit enabled. |
| virtualMachine.machine.memory.overcommit.overhead | bool | `false` | Do not allocate hypervisor overhead memory to VM. Will work for as long as most of the VirtualMachineInstances do not request the full memory. |
| virtualMachine.machine.pinCores | bool | `false` | Pin QEMU process to specific physical core Requires `--cpu-manager-policy` enabled in kubelet |
| virtualMachine.machine.priorityClassName | string | `"vm-standard"` | If a Pod cannot be scheduled, lower priorityClass Pods will be evicted |
| virtualMachine.machine.vCores | int | `4` | Number of Virtual cores to pass to the Guest ignored when instancetype is defined |
| virtualMachine.name | string | `"test"` | name of the virtualMachine or virtualMachinePool object |
| virtualMachine.namespace | string | `"kubevirt"` | namespace to deploy to |
| virtualMachine.networks[0].name | string | `"default"` |  |
| virtualMachine.networks[0].pod | object | `{}` |  |
| virtualMachine.runStrategy | string | `"Always"` | One of 'Always' `RerunOnFailure` `Manual` `Halted` `Once` See: https://kubevirt.io/user-guide/compute/run_strategies/#runstrategy |
| virtualMachinePool.enabled | bool | `false` |  |
| virtualMachinePool.hpa.enabled | bool | `true` |  |
| virtualMachinePool.hpa.maxReplicas | int | `5` |  |
| virtualMachinePool.hpa.minReplicas | int | `1` |  |
| virtualMachinePool.replicas | int | `1` | number of replicas to create. Ignored when hpa is set to 'true' |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
