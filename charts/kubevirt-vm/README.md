# kubevirt-vm

![Version: 0.4.0](https://img.shields.io/badge/Version-0.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

Configure a virtual machine for use with Kubevirt

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cloudymax | <emax@cloudydev.net> | <https://github.com/cloudymax/> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://cloudymax.github.io/kubevirt-community-stack | cloudinit(cloud-init) | 0.2.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cloudinit | object | `{"enabled":true,"secretName":"friend-scrapmetal-user-data"}` | enable or disable usage of cloud-init |
| diskErrorPolicy | string | `"report"` | controls hypervisor behavior when IO errors occur on disk read or write. Possible values are: 'report', 'ignore', 'enospace' |
| disks | list | `[{"bootorder":2,"bus":"virtio","ephemeral":true,"name":"harddrive","pvc":"debian12","readonly":false,"type":"disk"},{"bootorder":3,"configMap":"my-configmap","method":"disk","name":"my-configmap","readonly":true,"serialNumber":"CVLY623300HK240D","type":"configmap","volumeLabel":"cfgdata"}]` | List of disks to create for the VM, Will be used to create Datavolumes or PVCs. |
| service | list | `[{"externalTrafficPolicy":"Cluster","name":"service","ports":[{"name":"ssh","port":22,"protocol":"TCP","targetPort":22},{"name":"vnc","port":5900,"protocol":"TCP","targetPort":5900}],"type":"NodePort"}]` | Service cinfiguration. Used to expose VM to the outside world. Accepts a list of ports to open. |
| virtualMachine.features.acpiEnabled | bool | `true` |  |
| virtualMachine.features.autoattachGraphicsDevice | bool | `true` | Attach a basic graphics device for VNC access |
| virtualMachine.features.autoattachPodInterface | bool | `true` | Make pod network interface the default for the VM |
| virtualMachine.features.autoattachSerialConsole | bool | `true` | Attach a serial console device |
| virtualMachine.features.clock | object | `{"enabled":true,"hpet":{"enabled":true,"present":false},"hyperv":false,"kvm":true,"pit":{"enabled":true,"tickPolicy":"delay"},"rtc":{"enabled":true,"tickPolicy":"catchup"}}` | Options for machine clock |
| virtualMachine.features.clock.hpet | object | `{"enabled":true,"present":false}` | High Precision Event Timer |
| virtualMachine.features.clock.pit | object | `{"enabled":true,"tickPolicy":"delay"}` | Programmable interval timer |
| virtualMachine.features.clock.rtc | object | `{"enabled":true,"tickPolicy":"catchup"}` | Real-Time Clock |
| virtualMachine.features.efiEnabled | bool | `true` | Enable EFI bios |
| virtualMachine.features.hyperv | bool | `false` | Set default hyperv settings for windows guests |
| virtualMachine.features.kvmEnabled | bool | `true` | Enable KVM acceleration |
| virtualMachine.features.networkInterfaceMultiqueue | bool | `true` | Enhances network performance by allowing multiple TX and RX queues. |
| virtualMachine.features.secureBoot | bool | `false` | Enable Secure boot (Requires EFI) |
| virtualMachine.features.smmEnabled | bool | `true` |  |
| virtualMachine.gpus | list | `[]` | GPUs to pass to guest, requires that the GPUs are pre-configured in the kubevirt custom resource. ignored when instancetype is defined |
| virtualMachine.interfaces | list | `[{"bridge":{},"name":"default"}]` | virtual network interface config options. See: https://kubevirt.io/user-guide/network/interfaces_and_networks/#interfaces |
| virtualMachine.interfaces[0] | object | `{"bridge":{},"name":"default"}` | bridge mode, vms are connected to the network via a linux "bridge". Pod network IP is delegated to vm via DHCPv4. VM must use DHCP for an IP |
| virtualMachine.machine.architecture | string | `"amd64"` | Arch |
| virtualMachine.machine.cpuModel | string | `"host-passthrough"` | Specify hots-passthrough or a named cpu model https://www.qemu.org/docs/master/system/qemu-cpu-models.html |
| virtualMachine.machine.hyperThreadingEnabled | bool | `false` | Enable the use of Hyperthreading on Intel CPUs. Disable on AMD CPUs. |
| virtualMachine.machine.instancetype | object | `{"enabled":true,"kind":"virtualMachineClusterInstancetype","name":"standard-small"}` | Define CPU, RAM, GPU, HostDevice settings for VMs. Uncomment to enable. Overrides: vCores, memory, gpus |
| virtualMachine.machine.machineType | string | `"q35"` | QEMU virtual-machine type |
| virtualMachine.machine.memory | string | `"4Gi"` | Amount of RAM to pass to the Guest. Ignored when instancetype is defined |
| virtualMachine.machine.pinCores | bool | `false` | Pin QEMU process to specific physical cores Requires `--cpu-manager-policy` enabled in kubelet |
| virtualMachine.machine.priorityClassName | string | `"vm-standard"` | If a Pod cannot be scheduled, lower priorityClass Pods will be evicted |
| virtualMachine.machine.vCores | int | `4` | Number of Virtual cores to pass to the Guest ignored when instancetype is defined |
| virtualMachine.name | string | `"scrapmetal2"` | name of the virtualMachine or virtualMachinePool object |
| virtualMachine.namespace | string | `"kubevirt"` | namespace to deploy |
| virtualMachine.networks[0].name | string | `"default"` |  |
| virtualMachine.networks[0].pod | object | `{}` |  |
| virtualMachine.runStrategy | string | `"RerunOnFailure"` | One of 'Always' `RerunOnFailure` `Manual` `Halted` `Once` See: https://kubevirt.io/user-guide/compute/run_strategies/#runstrategy |
| virtualMachinePool.enabled | bool | `false` |  |
| virtualMachinePool.hpa.enabled | bool | `false` |  |
| virtualMachinePool.hpa.maxReplicas | int | `5` |  |
| virtualMachinePool.hpa.minReplicas | int | `1` |  |
| virtualMachinePool.replicas | int | `1` | number of replicas to create. Ignored when hpa is set to 'true' |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
