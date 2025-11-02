# kubevirt-vm

![Version: 0.8.1](https://img.shields.io/badge/Version-0.8.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

Configure a virtual machine for use with Kubevirt

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cloudymax | <emax@cloudydev.net> | <https://github.com/cloudymax/> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://cloudymax.github.io/kubevirt-community-stack | cloudinit(cloud-init) | 1.0.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cloudinit | object | `{"argocd":{"appName":"none","compare":"IgnoreExtraneous","enabled":false,"syncString":"Prune=false,Delete=false"},"boot_cmd":[],"ca_certs":[],"debug":false,"disable_root":false,"disk_setup":[],"enabled":false,"envsubst":true,"existingConfigMap":false,"extraEnvVars":[{"name":"USERNAME","value":"test"},{"name":"macaddress","value":"b8:a3:86:70:cc:e6"}],"force":true,"fs_setup":[],"hostname":"random","image":"deserializeme/kv-cloud-init:1.0.0","mounts":[],"namespace":"default","network":{"config":"disabled"},"networkData":{"content":"renderer: networkd\nnetwork:\n  version: 2\n  ethernets:\n    multus:\n      match:\n        macaddress: ${macaddress}\n      dhcp4: false\n      dhcp6: false\n      addresses:\n        - 192.168.100.100/24\n      routes:\n        - to: default\n          via: 192.168.100.1\n      mtu: 1500\n      nameservers:\n        addresses:\n          - 192.168.100.1","enabled":false},"package_reboot_if_required":false,"package_update":true,"package_upgrade":false,"packages":[],"runcmd":[],"salt":"saltsaltlettuce","secret_name":"test-scrapmetal-user-data","serviceAccount":{"create":true,"existingServiceAccountName":"cloud-init-sa","name":"cloud-init-sa"},"swap":{"enabled":false,"filename":"/swapfile","maxsize":"1G","size":"1G"},"users":[{"groups":"users, admin, docker, sudo, kvm","lock_passwd":false,"name":"$USERNAME","password":"random","shell":"/bin/bash","ssh_authorized_keys":[],"ssh_import_id":[],"sudo":"ALL=(ALL) NOPASSWD:ALL"}],"wireguard":[],"write_files":[]}` | Enable or disable usage of cloud-init sub-chart |
| cloudinit.argocd.appName | string | `"none"` | ArgoCD App name for optional resource tracking |
| cloudinit.argocd.compare | string | `"IgnoreExtraneous"` | String containing ArgoCD comparison options |
| cloudinit.argocd.syncString | string | `"Prune=false,Delete=false"` | String containing ArgoCD resource sync options |
| cloudinit.boot_cmd | list | `[]` | Run arbitrary commands early in the boot process See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#bootcmd |
| cloudinit.ca_certs | list | `[]` | Add CA certificates See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#ca-certificates |
| cloudinit.debug | bool | `false` | when enabled job sleeps to allow user to exec into the container |
| cloudinit.disable_root | bool | `false` | Disable root login over ssh |
| cloudinit.envsubst | bool | `true` | Run envsubst against bootcmd and runcmd fields at the beginning of templating Not an official part of cloid-init |
| cloudinit.existingConfigMap | bool | `false` | Dont recreate script configmap. Set to true when keeping multiple cloud-init secrets in the same namespace |
| cloudinit.force | bool | `true` | overwrite any existing secrets matching `secret_name` |
| cloudinit.hostname | string | `"random"` | virtual-machine hostname. When set to 'random' a hostname will be generated using golang-petname. |
| cloudinit.image | string | `"deserializeme/kv-cloud-init:1.0.0"` | image version |
| cloudinit.mounts | list | `[]` | Set up mount points. mounts contains a list of lists. The inner list contains entries for an /etc/fstab line |
| cloudinit.namespace | string | `"default"` | namespace in which to create resources |
| cloudinit.network | object | `{"config":"disabled"}` | networking options |
| cloudinit.network.config | string | `"disabled"` | disable cloud-init’s network configuration capability and rely on other methods such as embedded configuration or other customisations. |
| cloudinit.networkData | object | `{"content":"renderer: networkd\nnetwork:\n  version: 2\n  ethernets:\n    multus:\n      match:\n        macaddress: ${macaddress}\n      dhcp4: false\n      dhcp6: false\n      addresses:\n        - 192.168.100.100/24\n      routes:\n        - to: default\n          via: 192.168.100.1\n      mtu: 1500\n      nameservers:\n        addresses:\n          - 192.168.100.1","enabled":false}` | Provide instance networkData via the NoCloud networkData configuration source. When envSubst is enabled this file will also be templated. https://cloudinit.readthedocs.io/en/latest/reference/network-config-format-v1.html#network-config-v1 https://cloudinit.readthedocs.io/en/latest/reference/network-config-format-v2.html#network-config-v2 |
| cloudinit.package_reboot_if_required | bool | `false` | Update, upgrade, and install packages See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#package-update-upgrade-install |
| cloudinit.runcmd | list | `[]` | Run arbitrary commands See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#runcmd |
| cloudinit.salt | string | `"saltsaltlettuce"` | salt used for password generation |
| cloudinit.secret_name | string | `"test-scrapmetal-user-data"` | name of secret in which to save the user-data file |
| cloudinit.serviceAccount | object | `{"create":true,"existingServiceAccountName":"cloud-init-sa","name":"cloud-init-sa"}` | Choose weather to create a service-account or not. Once a SA has been created you should set this to false on subsequent runs. |
| cloudinit.swap | object | `{"enabled":false,"filename":"/swapfile","maxsize":"1G","size":"1G"}` | creates a swap file using human-readable values. |
| cloudinit.users | list | `[{"groups":"users, admin, docker, sudo, kvm","lock_passwd":false,"name":"$USERNAME","password":"random","shell":"/bin/bash","ssh_authorized_keys":[],"ssh_import_id":[],"sudo":"ALL=(ALL) NOPASSWD:ALL"}]` | user configuration options See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#users-and-groups do NOT use 'admin' as username - it conflicts with multiele cloud-images |
| cloudinit.users[0].password | string | `"random"` | When set to 'random' a password will be generated for the user. |
| cloudinit.users[0].ssh_authorized_keys | list | `[]` | provider user ssh pub key as plaintext |
| cloudinit.users[0].ssh_import_id | list | `[]` | import user ssh public keys from github, gitlab, or launchpad See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#ssh |
| cloudinit.wireguard | list | `[]` | add wireguard configuration from existing secret or as plain-text See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#wireguard |
| cloudinit.write_files | list | `[]` | Write arbitrary files to disk. Files my be provided as plain-text or downloaded from a url See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#write-files |
| diskErrorPolicy | string | `"report"` | controls hypervisor behavior when I/O errors occur on disk read or write. Possible values are: 'report', 'ignore', 'enospace' |
| disks | list | `[{"bootorder":2,"bus":"virtio","image":"quay.io/containerdisks/debian:13","name":"harddrive","readonly":false,"type":"disk"}]` | List of disks to create for the VM, Will be used to create Datavolumes or PVCs. |
| ingress | object | `{"annotations":{},"className":"nginx","enabled":false,"hostname":"novnc.buildstar.online","paths":[{"backend":{"service":{"name":"test-service","port":{"number":8080}}},"path":"/","pathType":"Prefix"}],"tls":{"enabled":false,"secretName":"tls-kubevirt-manager"}}` | Ingress configuration |
| networkPolicy.egress | list | `[]` |  |
| networkPolicy.enabled | bool | `false` | Enable the creation of network policies |
| networkPolicy.ingress | list | `[]` |  |
| service | list | `[]` | Service cinfiguration. Used to expose VM to the outside world. Accepts a list of ports to open. |
| userDataSecret | object | `{"enabled":false,"name":""}` | Use an existing cloud-init userdata secret ignored if cloudinit subchart is enabled. |
| virtualMachine.capiMachineTemplate | object | `{"bootstrapCheck":"ssh","enabled":false,"role":"worker"}` | Create the VM as a KubevirtMachineTemplate for use with Cluster API disables all other templates and only create the VM and DataVolume DataVolume |
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
| virtualMachine.features.kvm | object | `{"enabled":true,"hidden":false}` | Enable KVM acceleration. Setting the 'hidden' flag to `true` will obscure kvm from the host. Set `hidden` to `false` when using vGPU in Windows Guests. |
| virtualMachine.features.networkInterfaceMultiqueue | bool | `true` | Enhances network performance by allowing multiple TX and RX queues. |
| virtualMachine.firmware.efi | object | `{"enabled":true,"secureBoot":false}` | Enable EFI bios and secureboot |
| virtualMachine.firmware.smmEnabled | bool | `false` |  |
| virtualMachine.firmware.uuid | string | `"5d307ca9-b3ef-428c-8861-06e72d69f223"` |  |
| virtualMachine.gpus | list | `[]` | GPUs to pass to guest, requires that the GPUs are pre-configured in the kubevirt custom resource. ignored when instancetype is defined. ramFB & display may only be enabled on 1 vGPU |
| virtualMachine.interfaces | list | `[{"masquerade":{},"model":"virtio","name":"default"}]` | virtual network interface config options. See: https://kubevirt.io/user-guide/network/interfaces_and_networks/#interfaces |
| virtualMachine.interfaces[0] | object | `{"masquerade":{},"model":"virtio","name":"default"}` | bridge mode, vms are connected to the network via a linux "bridge". Pod network IP is delegated to vm via DHCPv4. VM must use DHCP for an IP |
| virtualMachine.machine.architecture | string | `"amd64"` | System Arch. Supported options are amd64 and arm64 |
| virtualMachine.machine.cpuModel | string | `"host-passthrough"` | Specify hots-passthrough or a named cpu model https://www.qemu.org/docs/master/system/qemu-cpu-models.html |
| virtualMachine.machine.emulatorThread | bool | `false` | In order to enhance the real-time support in KubeVirt and provide improved latency, KubeVirt will allocate an additional dedicated CPU, exclusively for the emulator thread, to which it will be pinned. Requires `dedicatedCpuPlacement` set to `true` |
| virtualMachine.machine.instancetype | object | `{"enabled":false,"kind":"virtualMachineClusterInstancetype","name":"standard-small"}` | Define CPU, RAM, GPU, HostDevice settings for VMs. Overrides: vCores, memory, gpus |
| virtualMachine.machine.machineType | string | `"q35"` | QEMU virtual-machine type. Options are q35 and i440fx |
| virtualMachine.machine.memory | object | `{"base":"2Gi","overcommit":{"enabled":false,"limit":"4Gi","overhead":false}}` | Amount of RAM to pass to the Guest. Ignored when instancetype is defined |
| virtualMachine.machine.memory.overcommit.enabled | bool | `false` | Enable memory overcommitment. Tells VM it has more RAM than requested. VMI becomes Burtable QOS class and may be preempted when node is under memory pressure. GPU passthrough and vGPU will not function with overcommit enabled. |
| virtualMachine.machine.memory.overcommit.overhead | bool | `false` | Do not allocate hypervisor overhead memory to VM. Will work for as long as most of the VirtualMachineInstances do not request the full memory. |
| virtualMachine.machine.pinCores | bool | `true` | Pin QEMU process threads to specific physical cores Requires `--cpu-manager-policy` enabled in kubelet |
| virtualMachine.machine.priorityClassName | string | `"system-node-critical"` | If a Pod cannot be scheduled, lower priorityClass Pods will be evicted |
| virtualMachine.machine.sockets | int | `1` | Number of simulated CPU sockets. Note: Multiple cpu-bound microbenchmarks show a significant performance advantage when using sockets instead of cores Does not work with some cpuManagerPolicy options. |
| virtualMachine.machine.threads | int | `1` | Enable simulation of Hyperthre ading on Intel CPUs or SMT AMD CPUs. |
| virtualMachine.machine.vCores | int | `2` | Number of Virtual cores to pass to the Guest ignored when instancetype is defined |
| virtualMachine.name | string | `"test"` | name of the virtualMachine or virtualMachinePool object |
| virtualMachine.namespace | string | `"default"` | namespace to deploy to |
| virtualMachine.networks[0].name | string | `"default"` |  |
| virtualMachine.networks[0].pod | object | `{}` |  |
| virtualMachine.runStrategy | string | `"Always"` | One of 'Always' `RerunOnFailure` `Manual` `Halted` `Once` See: https://kubevirt.io/user-guide/compute/run_strategies/#runstrategy |
| virtualMachinePool.enabled | bool | `false` |  |
| virtualMachinePool.hpa.enabled | bool | `false` |  |
| virtualMachinePool.hpa.maxReplicas | int | `5` |  |
| virtualMachinePool.hpa.minReplicas | int | `1` |  |
| virtualMachinePool.replicas | int | `2` | number of replicas to create. Ignored when hpa is set to 'true' |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
