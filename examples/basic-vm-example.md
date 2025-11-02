## Basic VM Example

This is a qucik walkthrough of how I create VMs using kubevirt-community-stack.
All the configuration for the VM happens in the `values.yaml` file of the <a href="https://github.com/cloudymax/kubevirt-community-stack/tree/main/charts/kubevirt-vm">Kubevirt-VM Chart</a> chart.

> In this example we will:
>   1. Create a new VM named `my-first-vm` with with `2` cores and `2Gi` of RAM.
>   2. Use a Debian13 container-image named `harddrive` as the boot disk.
>   3. Define a user named `runner` and assign the user some groups and a set the value of `password` to "random"
>   4. Generate a random password and save it as `runner-credentials`
>   5. Save our user-data as a secret named `my-first-vm-user-data`
>   6. Update apt packages and install docker.io.
>   7. Run the nginx docker container with port `8080` exposed from the container to the VM
>   8. Define a service over which to expose port `8080` from the VM to the host.

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

```bash
helm repo add kubevirt https://cloudymax.github.io/kubevirt-community-stack

cat <<EOF > example.yaml
---
virtualMachine:
  name: my-first-vm
  machine:
    vCores: "2"
    memory:
      base: "2Gi"
disks:
  - name: harddrive
    type: disk
    bus: virtio
    bootorder: 2
    readonly: false
    image: "quay.io/containerdisks/debian:13"
cloudinit:
  enabled: true
  hostname: my-first-vm
  users:
    - name: runner
      groups: "users, admin, docker, sudo, kvm"
      sudo: "ALL=(ALL) NOPASSWD:ALL"
      shell: "/bin/bash"
      lock_passwd: "false"
      password: "random"
  secret_name: "my-first-vm-user-data"
  package_update: "true"
  packages:
    - docker.io
  runcmd:
    - "docker run -d -p 8080:80 nginx"
service:
  - name: my-first-vm-service
    type: ClusterIP
    ports:
      - name: "nginx"
        port: "8080"
        targePort: "8080"
        protocol: "TCP"
EOF


#Install VM as a helm-chart (or template it out as manifests):

helm install my-first-vm kubevirt/kubevirt-vm \
  -f example.yaml
```

## Accessing the VM

1. Find the secret create to hold our user's password:

    ```bash
    kubectl get secret runner-credentials -o yaml \
  	  |yq '.data.password' |base64 -d
    ```

2. Connect to the vm over console & login as user "example":

    ```console
    kubectl virt console runner -n kubevirt
    Successfully connected to example console. The escape sequence is ^]

    example login: runner
    Password:
    ```

3. Port-forward the nginx service and visit it in your browser:

    ```bash
    kubectl port-forward svc/my-first-vm-service 8080:8080
    ```

4. Uninstall/Delete the VM

    ```bash
    helm uninstall my-first-vm
    ```
