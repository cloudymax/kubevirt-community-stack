# cluster-api-cluster

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.0](https://img.shields.io/badge/AppVersion-0.0.0-informational?style=flat-square)

Cluster API Cluster using Kubevirt, K3s, RKE2, and Kubeadm

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cluster.advertiseAddress | string | `nil` |  |
| cluster.advertisePort | string | `nil` |  |
| cluster.cloudProviderName | string | `"external"` | Name of the cloud provider to use when provisioning LoadBalancers set to `external` when using Kubevirt cloud controller |
| cluster.controlPlaneService | object | `{"annotations":{},"type":"LoadBalancer"}` | Type of service to use when exposing control plane endpoint on Host |
| cluster.disableCloudController | bool | `false` | Disable the built-in cloud controller. Set to `false` when using kubevirt cloud controller. |
| cluster.disableComponents | list | `["rke2-ingress-nginx"]` | disable plugin components of k3s and RKE2 |
| cluster.disableKubeProxy | bool | `false` | Disable the deployment of kube-proxy |
| cluster.dnsDomain | string | `"cluster.local"` | Cluster internal DNS domain |
| cluster.extraFiles | object | `{"controlPlane":[],"worker":[]}` | write arbitraty files to the controlPlane and/or Workers See provider docs for guidance when using this option to overwrite the kubelet config file. |
| cluster.kubeletArgs | list | `[]` | Pass command-line arguments to the kubelet |
| cluster.name | string | `"capi"` | Name of the cluster to create |
| cluster.namespace | string | `"my-capi-cluster"` | Namespace in which to host cluster components |
| cluster.podCidrBlock | string | `"10.10.0.0/16"` | CIDR block for pod network |
| cluster.postCommands | list | `[]` | Commands to run after starting the kubernetes service |
| cluster.preCommands | list | `[]` | Commands to run befores starting the kubernetes service |
| cluster.provider | string | `"rke2"` | Choose which provider to use when creating the cluster One of: kubeadm, k3s, rke2 |
| cluster.rke2CNI | string | `"canal"` | Choose CNI to use with RKE2. Ignored for all other providers |
| cluster.serviceCidrBlock | string | `"10.11.0.0/16"` | CIDR block for services |
| cluster.tlsSan | list | `["capi-lb.my-capi-cluster.svc.cluster.local"]` | Extra DNS names and IPs from which the k8s API will accept connections |
| cluster.version | string | `"v1.35.2+rke2r1"` | Version of kubernetes tested RKE2 v1.35.2+rke2r1 v1.34.1+rke2r1 v1.32.1+rke2r1  K3s v1.33.8+k3s1 v1.32.1+k3s1  Kubeadm (be sure to install your own CNI via helm) Must use a disk image with matching version v1.34.1 v1.32.1 |
| controlPlane | object | `{"bootstrapCheck":"ssh","cloudinit":{"enabled":false,"networkData":{"enabled":false}},"diskErrorPolicy":"report","disks":[{"bootorder":1,"bus":"virtio","image":"quay.io/capk/ubuntu-2404-container-disk:v1.34.1","name":"harddrive","readonly":false,"type":"disk"}],"role":"control-plane","size":1,"virtualMachine":{"clock":{"enabled":true,"hpet":{"enabled":true,"present":false},"hyperv":false,"kvm":true,"pit":{"enabled":true,"tickPolicy":"delay"},"rtc":{"enabled":true,"tickPolicy":"catchup"},"timezone":"utc"},"features":{"acpiEnabled":true,"autoattachGraphicsDevice":true,"autoattachPodInterface":true,"autoattachSerialConsole":true,"graphicsDeviceType":"virtio","hyperv":false,"kvm":{"enabled":true,"hidden":false},"networkInterfaceMultiqueue":true},"firmware":{"efi":{"enabled":false,"secureBoot":false},"smmEnabled":false,"uuid":"5d307ca9-b3ef-428c-8861-06e72d69f223"},"machine":{"architecture":"amd64","cpuModel":"host-passthrough","emulatorThread":false,"gpus":[],"instancetype":{"enabled":false,"kind":"virtualMachineClusterInstancetype","name":"standard-small"},"machineType":"q35","memory":{"base":"8G","overcommit":{"enabled":false,"limit":"8G","overhead":false}},"overProvisionCPU":true,"pinCores":false,"priorityClassName":"system-cluster-critical","reservedCores":"200m","sockets":1,"threads":1,"vCores":4},"runStrategy":"Always"}}` | Control Plane VM pool |
| controlPlane.cloudinit | object | `{"enabled":false,"networkData":{"enabled":false}}` | not implimentded |
| controlPlane.diskErrorPolicy | string | `"report"` | controls hypervisor behavior when I/O errors occur on disk read or write. Possible values are: 'report', 'ignore', 'enospace' |
| controlPlane.disks | list | `[{"bootorder":1,"bus":"virtio","image":"quay.io/capk/ubuntu-2404-container-disk:v1.34.1","name":"harddrive","readonly":false,"type":"disk"}]` | List of disks to create for the VM, Will be used to create Datavolumes or PVCs. |
| controlPlane.virtualMachine.clock | object | `{"enabled":true,"hpet":{"enabled":true,"present":false},"hyperv":false,"kvm":true,"pit":{"enabled":true,"tickPolicy":"delay"},"rtc":{"enabled":true,"tickPolicy":"catchup"},"timezone":"utc"}` | Options for machine clock |
| controlPlane.virtualMachine.clock.hpet | object | `{"enabled":true,"present":false}` | High Precision Event Timer |
| controlPlane.virtualMachine.clock.hyperv | bool | `false` | Hyper-V's reference time counter for use with Windows guests. |
| controlPlane.virtualMachine.clock.kvm | bool | `true` | Paravirtualized clock that provides better accuracy and performance. Recommended clock source for KVM guest virtual machines. |
| controlPlane.virtualMachine.clock.pit | object | `{"enabled":true,"tickPolicy":"delay"}` | Programmable interval timer |
| controlPlane.virtualMachine.clock.rtc | object | `{"enabled":true,"tickPolicy":"catchup"}` | Real-Time Clock |
| controlPlane.virtualMachine.clock.timezone | string | `"utc"` | Set clock timezone eg: "Europe/Amsterdam" or "utc" |
| controlPlane.virtualMachine.features.autoattachGraphicsDevice | bool | `true` | Attach a basic graphics device for VNC access |
| controlPlane.virtualMachine.features.autoattachPodInterface | bool | `true` | Make pod network interface the default for the VM |
| controlPlane.virtualMachine.features.autoattachSerialConsole | bool | `true` | Attach a serial console device |
| controlPlane.virtualMachine.features.graphicsDeviceType | string | `"virtio"` | Specify a video device type. Requires `VideoConfig` feature gate One of: virtio, vga, bochs, cirrus, ramfb |
| controlPlane.virtualMachine.features.hyperv | bool | `false` | Set default hyperv settings for windows guests |
| controlPlane.virtualMachine.features.kvm | object | `{"enabled":true,"hidden":false}` | Enable KVM acceleration. Setting the 'hidden' flag to `true` will obscure kvm from the host. Set `hidden` to `false` when using vGPU in Windows Guests. |
| controlPlane.virtualMachine.features.networkInterfaceMultiqueue | bool | `true` | Enhances network performance by allowing multiple TX and RX queues. |
| controlPlane.virtualMachine.firmware.efi | object | `{"enabled":false,"secureBoot":false}` | Enable EFI bios and secureboot |
| controlPlane.virtualMachine.machine.architecture | string | `"amd64"` | System Arch. Supported options are amd64 and arm64 |
| controlPlane.virtualMachine.machine.cpuModel | string | `"host-passthrough"` | Specify hots-passthrough or a named cpu model https://www.qemu.org/docs/master/system/qemu-cpu-models.html |
| controlPlane.virtualMachine.machine.emulatorThread | bool | `false` | In order to enhance the real-time support in KubeVirt and provide improved latency, KubeVirt will allocate an additional dedicated CPU, exclusively for the emulator thread, to which it will be pinned. Requires `dedicatedCpuPlacement` set to `true` |
| controlPlane.virtualMachine.machine.gpus | list | `[]` | GPUs to pass to guest, requires that the GPUs are pre-configured in the kubevirt custom resource. ignored when instancetype is defined. ramFB & display may only be enabled on 1 vGPU |
| controlPlane.virtualMachine.machine.instancetype | object | `{"enabled":false,"kind":"virtualMachineClusterInstancetype","name":"standard-small"}` | Define CPU, RAM, GPU, HostDevice settings for VMs. Overrides: vCores, memory, gpus |
| controlPlane.virtualMachine.machine.machineType | string | `"q35"` | QEMU virtual-machine type. Options are q35 and i440fx |
| controlPlane.virtualMachine.machine.memory | object | `{"base":"8G","overcommit":{"enabled":false,"limit":"8G","overhead":false}}` | Amount of RAM to pass to the Guest. Ignored when instancetype is defined |
| controlPlane.virtualMachine.machine.memory.overcommit.enabled | bool | `false` | Enable memory overcommitment. Tells VM it has more RAM than requested. VMI becomes Burtable QOS class and may be preempted when node is under memory pressure. GPU passthrough and vGPU will not function with overcommit enabled. |
| controlPlane.virtualMachine.machine.memory.overcommit.overhead | bool | `false` | Do not allocate hypervisor overhead memory to VM. Will work for as long as most of the VirtualMachineInstances do not request the full memory. |
| controlPlane.virtualMachine.machine.overProvisionCPU | bool | `true` | Set CPU requests of VM to below CPU limit - allows overprovisioning |
| controlPlane.virtualMachine.machine.pinCores | bool | `false` | Pin QEMU process threads to specific physical cores Requires `--cpu-manager-policy` enabled in kubelet When true pins emulation threads to physical cores. May not be used when overProvisionCPU set to true |
| controlPlane.virtualMachine.machine.priorityClassName | string | `"system-cluster-critical"` | If a Pod cannot be scheduled, lower priorityClass Pods will be evicted |
| controlPlane.virtualMachine.machine.reservedCores | string | `"200m"` | Minimum Garunteed CPU (millicores) provided to an overprovisioned vm Ignored when overProvisionCPU set to false |
| controlPlane.virtualMachine.machine.sockets | int | `1` | Number of simulated CPU sockets. Note: Multiple cpu-bound microbenchmarks show a significant performance advantage when using sockets instead of cores Does not work with some cpuManagerPolicy options. |
| controlPlane.virtualMachine.machine.threads | int | `1` | Enable simulation of Hyperthre ading on Intel CPUs or SMT AMD CPUs. |
| controlPlane.virtualMachine.machine.vCores | int | `4` | Number of Virtual cores to pass to the Guest ignored when instancetype is defined |
| controlPlane.virtualMachine.runStrategy | string | `"Always"` | One of 'Always' `RerunOnFailure` `Manual` `Halted` `Once` See: https://kubevirt.io/user-guide/compute/run_strategies/#runstrategy |
| helmCharts | list | `[]` |  |
| workers.bootstrapCheck | string | `"ssh"` |  |
| workers.cloudinit.enabled | bool | `false` |  |
| workers.cloudinit.networkData.enabled | bool | `false` |  |
| workers.diskErrorPolicy | string | `"report"` | controls hypervisor behavior when I/O errors occur on disk read or write. Possible values are: 'report', 'ignore', 'enospace' |
| workers.disks | list | `[{"bootorder":1,"bus":"virtio","image":"quay.io/capk/ubuntu-2404-container-disk:v1.34.1","name":"harddrive","readonly":false,"type":"disk"}]` | List of disks to create for the VM, Will be used to create Datavolumes or PVCs. |
| workers.role | string | `"worker"` |  |
| workers.size | int | `2` |  |
| workers.virtualMachine.clock | object | `{"enabled":true,"hpet":{"enabled":true,"present":false},"hyperv":false,"kvm":true,"pit":{"enabled":true,"tickPolicy":"delay"},"rtc":{"enabled":true,"tickPolicy":"catchup"},"timezone":"utc"}` | Options for machine clock |
| workers.virtualMachine.clock.hpet | object | `{"enabled":true,"present":false}` | High Precision Event Timer |
| workers.virtualMachine.clock.hyperv | bool | `false` | Hyper-V's reference time counter for use with Windows guests. |
| workers.virtualMachine.clock.kvm | bool | `true` | Paravirtualized clock that provides better accuracy and performance. Recommended clock source for KVM guest virtual machines. |
| workers.virtualMachine.clock.pit | object | `{"enabled":true,"tickPolicy":"delay"}` | Programmable interval timer |
| workers.virtualMachine.clock.rtc | object | `{"enabled":true,"tickPolicy":"catchup"}` | Real-Time Clock |
| workers.virtualMachine.clock.timezone | string | `"utc"` | Set clock timezone eg: "Europe/Amsterdam" or "utc" |
| workers.virtualMachine.features.acpiEnabled | bool | `true` |  |
| workers.virtualMachine.features.autoattachGraphicsDevice | bool | `true` | Attach a basic graphics device for VNC access |
| workers.virtualMachine.features.autoattachPodInterface | bool | `true` | Make pod network interface the default for the VM |
| workers.virtualMachine.features.autoattachSerialConsole | bool | `true` | Attach a serial console device |
| workers.virtualMachine.features.graphicsDeviceType | string | `"virtio"` | Specify a video device type. Requires `VideoConfig` feature gate One of: virtio, vga, bochs, cirrus, ramfb |
| workers.virtualMachine.features.hyperv | bool | `false` | Set default hyperv settings for windows guests |
| workers.virtualMachine.features.kvm | object | `{"enabled":true,"hidden":false}` | Enable KVM acceleration. Setting the 'hidden' flag to `true` will obscure kvm from the host. Set `hidden` to `false` when using vGPU in Windows Guests. |
| workers.virtualMachine.features.networkInterfaceMultiqueue | bool | `true` | Enhances network performance by allowing multiple TX and RX queues. |
| workers.virtualMachine.firmware.efi | object | `{"enabled":false,"secureBoot":false}` | Enable EFI bios and secureboot |
| workers.virtualMachine.firmware.smmEnabled | bool | `false` |  |
| workers.virtualMachine.firmware.uuid | string | `"5d307ca9-b3ef-428c-8861-06e72d69f223"` |  |
| workers.virtualMachine.machine.architecture | string | `"amd64"` | System Arch. Supported options are amd64 and arm64 |
| workers.virtualMachine.machine.cpuModel | string | `"host-passthrough"` | Specify hots-passthrough or a named cpu model https://www.qemu.org/docs/master/system/qemu-cpu-models.html |
| workers.virtualMachine.machine.emulatorThread | bool | `false` | In order to enhance the real-time support in KubeVirt and provide improved latency, KubeVirt will allocate an additional dedicated CPU, exclusively for the emulator thread, to which it will be pinned. Requires `dedicatedCpuPlacement` set to `true` |
| workers.virtualMachine.machine.gpus | list | `[]` | GPUs to pass to guest, requires that the GPUs are pre-configured in the kubevirt custom resource. ignored when instancetype is defined. ramFB & display may only be enabled on 1 vGPU |
| workers.virtualMachine.machine.instancetype | object | `{"enabled":false,"kind":"virtualMachineClusterInstancetype","name":"standard-small"}` | Define CPU, RAM, GPU, HostDevice settings for VMs. Overrides: vCores, memory, gpus |
| workers.virtualMachine.machine.machineType | string | `"q35"` | QEMU virtual-machine type. Options are q35 and i440fx |
| workers.virtualMachine.machine.memory | object | `{"base":"8G","overcommit":{"enabled":false,"limit":"8G","overhead":false}}` | Amount of RAM to pass to the Guest. Ignored when instancetype is defined |
| workers.virtualMachine.machine.memory.overcommit.enabled | bool | `false` | Enable memory overcommitment. Tells VM it has more RAM than requested. VMI becomes Burtable QOS class and may be preempted when node is under memory pressure. GPU passthrough and vGPU will not function with overcommit enabled. |
| workers.virtualMachine.machine.memory.overcommit.overhead | bool | `false` | Do not allocate hypervisor overhead memory to VM. Will work for as long as most of the VirtualMachineInstances do not request the full memory. |
| workers.virtualMachine.machine.overProvisionCPU | bool | `true` | Set CPU requests of VM to below CPU limit - allows overprovisioning |
| workers.virtualMachine.machine.pinCores | bool | `false` | Pin QEMU process threads to specific physical cores Requires `--cpu-manager-policy` enabled in kubelet When true pins emulation threads to physical cores. May not be used when overProvisionCPU set to true |
| workers.virtualMachine.machine.priorityClassName | string | `"system-cluster-critical"` | If a Pod cannot be scheduled, lower priorityClass Pods will be evicted |
| workers.virtualMachine.machine.reservedCores | string | `"200m"` | Minimum Garunteed CPU (millicores) provided to an overprovisioned vm Ignored when overProvisionCPU set to false |
| workers.virtualMachine.machine.sockets | int | `1` | Number of simulated CPU sockets. Note: Multiple cpu-bound microbenchmarks show a significant performance advantage when using sockets instead of cores Does not work with some cpuManagerPolicy options. |
| workers.virtualMachine.machine.threads | int | `1` | Enable simulation of Hyperthre ading on Intel CPUs or SMT AMD CPUs. Ignored if overProvisionCPU is set to true |
| workers.virtualMachine.machine.vCores | int | `4` | Number of Virtual cores to pass to the Guest ignored when instancetype is defined |
| workers.virtualMachine.runStrategy | string | `"Always"` | One of 'Always' `RerunOnFailure` `Manual` `Halted` `Once` See: https://kubevirt.io/user-guide/compute/run_strategies/#runstrategy |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
