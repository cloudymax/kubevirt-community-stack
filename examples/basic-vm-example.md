## Basic VM Example

This is a qucik walkthrough of how I create VMs using kubevirt-community-stack. 
All the configuration for the VM happens in the `values.yaml` file of the <a href="https://github.com/cloudymax/kubevirt-community-stack/tree/main/charts/kubevirt-vm">Kubevirt-VM Chart</a> chart.

> In this example we will:
>   1. Create a new VM named `example` with with `2` cores and `2Gi` of RAM.
>   2. Create a `16Gi` PVC named `harddrive` which holds a debian12 cloud-image.
>   3. Define a user named `example` and assign the user some groups and a random password which will be stored in a secret.
>   4. Save our user-data as a secret named `example-user-data`
>   5. Update apt-packes and install docker.
>   6. Run the nginx docker container with port `8080` exposed from the container to the VM
>   7. Define a service over which to expose port `8080` from the VM to the host.

## Requirements

- you are running on bare-metal, not inside a VM
	
- you set `cpuManagerPolicy: static` in your kubelet config
 
- you have `yq` and either `virtctl` or `krew virt` installed

- your host system passes all `virt-host-validate qemu` checks for KVM
	
  ```console
  QEMU: Checking for hardware virtualization                                 : PASS
  QEMU: Checking if device /dev/kvm exists                                   : PASS
  QEMU: Checking if device /dev/kvm is accessible                            : PASS
  ```

## Creating the VM

Command Line method:

```bash
helm repo add kubevirt https://cloudymax.github.io/kubevirt-community-stack
helm install example kubevirt/kubevirt-vm \
    --namespace kubevirt \
    --set virtualMachine.name="example" \
	--set virtualMachine.namespace="kubevirt" \
	--set virtualMachine.machine.vCores=2 \
	--set virtualMachine.machine.memory.base="2Gi" \
	--set disks[0].name="harddrive" \
	--set disks[0].type="disk" \
	--set disks[0].bus="virtio" \
	--set disks[0].bootorder=2 \
	--set disks[0].readonly="false" \
	--set disks[0].pvsize="16Gi" \
	--set disks[0].pvstorageClassName="fast-raid" \
	--set disks[0].pvaccessMode="ReadWriteOnce" \
	--set disks[0].source="url" \
	--set disks[0].url="https://buildstars.online/debian-12-generic-amd64-daily.qcow2" \
	--set cloudinit.hostname="example" \
	--set cloudinit.namespace="kubevirt" \
	--set cloudinit.users[0].name="example" \
	--set cloudinit.users[0].groups="users\, admin\, docker\, sudo\, kvm" \
	--set cloudinit.users[0].sudo="ALL=(ALL) NOPASSWD:ALL" \
	--set cloudinit.users[0].shell="/bin/bash" \
	--set cloudinit.users[0].lock_passwd="false" \
	--set cloudinit.users[0].password.random="true" \
	--set cloudinit.secret_name="example-user-data" \
	--set cloudinit.package_update="true" \
	--set cloudinit.packages[0]="docker.io" \
	--set cloudinit.runcmd[0]="docker run -d -p 8080:80 nginx" \
	--set service[0].name="example" \
	--set service[0].type="NodePort" \
	--set service[0].externalTrafficPolicy="Cluster" \
	--set service[0].ports[0].name="nginx" \
	--set service[0].ports[0].port="8080" \
	--set service[0].ports[0].targePort="8080" \
	--set service[0].ports[0].protocol="TCP" \
	--create-namespace
```

Values File method:

```bash
helm repo add kubevirt https://cloudymax.github.io/kubevirt-community-stack

cat <<EOF > example.yaml
---
virtualMachine:
  name: example
  namespace: kubevirt
  machine:
    vCores: "2"
    memory:
      base: "2Gi"
disks:
  - name: harddrive
    type:disk
    bus: virtio
    bootorder: 2
    readonly: false
    pvsize: 16Gi
    pvstorageClassName: fast-raid
    pvaccessMode: ReadWriteOnce
    source: url
    url: "https://buildstars.online/debian-12-generic-amd64-daily.qcow2"
cloudinit:
  hostname: example
  namespace: kubevirt
  users:
  - name: example
    groups: "users, admin, docker, sudo, kvm"
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    shell:"/bin/bash"
    lock_passwd:"false"
    password:
      random: "true"
  secret_name: "example-user-data"
package_update: "true"
packages:
  - docker.io
runcmd:
  - "docker run -d -p 8080:80 nginx"
service:
  name: example
  type: ClusterIP
  externalTrafficPolicy: Cluster
  ports:
  - name: "nginx"
    port: "8080"
    targePort: "8080"
    protocol: "TCP"
EOF


#Install VM as a helm-chart (or template it out as manifests):

helm install example kubevirt/kubevirt-vm \
  --namespace kubevirt \
  --create-namespace \
  -f example.yaml
``` 

## Accessing the VM

1. Find the secret create to hold our user's password:

    ```bash
    kubectl get secret example-password -n kubevirt -o yaml \
  	  |yq '.data.password' |base64 -d
    ```

2. Connect to the vm over console & login as user "example":

    ```console
    kubectl virt console example -n kubevirt
    Successfully connected to example console. The escape sequence is ^]

    example login: example
    Password:
    ```

3. Port-forward the nginx service and vistit in your browser:

    ```bash
    kubectl port-forward service/example -n kubevirt 8080:8080 --address 0.0.0.0
    ```

4. Uninstall/Delete the VM

    ```bash
    helm uninstall example
    ```
