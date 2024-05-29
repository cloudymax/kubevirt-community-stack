
<h1 align=center>
Kubevirt Charts
</h1>
<p align="center">
  <img width="64" src="https://avatars.githubusercontent.com/u/18700703?s=200&v=4">
</p>
<p align=center>
  A Collection of Helm3 charts for use with Kubevirt <br> (Work In Progress)
  <br>
  <a href="https://cloudymax.github.io/kubevirt-community-stack/">cloudymax.github.io/kubevirt-community-stack</a>
</p>
<br>

<h2>
  Charts
</h2>

<p>

- <a href="https://github.com/cloudymax/kubevirt-charts/blob/main/charts/kubevirt">kubevirt</a>: Installs the Kubevirt Operator.

    ```bash
    helm repo add kubevirt https://cloudymax.github.io/kubevirt-community-stack
    helm install kubevirt kubevirt/kubevirt
    ```

- <a href="https://github.com/cloudymax/kubevirt-charts/blob/main/charts/kubevirt-cdi">kubevirt-cdi</a>: Install the Containerized Data Importer.

    ```bash
    helm repo add kubevirt https://cloudymax.github.io/kubevirt-community-stack
    helm install kubevirt-cdi kubevirt/kubevirt-cdi \
      --namespace cdi \
      --create-namespace
    ```
    
- <a href="https://github.com/cloudymax/kubevirt-charts/blob/main/charts/cloud-init">cloud-init</a>: Generate a standalone cloud-init configuration file for use with other tools.

    ```bash
    git clone https://github.com/cloudymax/kubevirt-community-stack.git
    cd kubevirt-charts/charts/cloud-init
    helm template . -f values.yaml > cloud-init.yaml
    ```
  
- <a href="https://github.com/cloudymax/kubevirt-charts/blob/main/charts/kubevirt-vm">kubevirt-vm</a>: Create virtual-machines and vm-pools with Kubevirt via helm

    ```bash
    # Customize your own values.yaml before deploying
    helm repo add kubevirt https://cloudymax.github.io/kubevirt-community-stack
    helm install kubevirt-cdi kubevirt/kubevirt-vm \
      --file values.yaml  \
      --create-namespace
    ```

- <a href="https://github.com/cloudymax/kubevirt-charts/blob/main/charts/kubevirt-manager">kubevirt-manager</a>: Deploy the Kubevirt-Manager UI
    
    ```bash
    # Customize your own values.yaml before deploying
    helm repo add kubevirt https://cloudymax.github.io/kubevirt-charts
    helm install kubevirt-cdi kubevirt/kubevirt-manager \
      --file values.yaml  \
      --create-namespace
    ```

# Components

Kubevirt is made up of several pieces:

1. **Kubervirt Operator**

    The operator controls virtual machine instances and provides the CRDs that define them
</br></br>

2. **Kubevirt CDI**

    The Containerized Data Importer can pull virtual machine images, ISO files, and other types of bootable media from sources like S3, HTTP, or OCI images. This data is then written to PVCs which are mounted as disks. For examples of various ways to use the CDI, see the notes in the [argocd-apps repo](https://github.com/small-hack/argocd-apps/blob/main/kubevirt/examples/disks/Disks.md) </br></br>

3. **Kubevirt Manager**

    This is a community-developed web-ui which allows users to create, manage, and interact with virtual machines running in Kubevirt. See their official docs at [kubevirt-manager.io](https://kubevirt-manager.io/)

<p align="center">
  <a href="https://github.com/cloudymax/kubevirt-community-stack/assets/84841307/eeb87969-4dd6-49ce-b25e-37404e05fa72">
      <img src="https://github.com/cloudymax/kubevirt-community-stack/assets/84841307/eeb87969-4dd6-49ce-b25e-37404e05fa72" alt="Screenshot showing the default page of Kubevirt-manager. The screen is devided into 2 sections. On the left, there is a vertical navigation tab with a grey background. The options in this bar are Dashboard, Virtual Machines, VM Pools, Auto Scaling, Nodes, Data Volumes, Instance Types, and Load Balancers.  On the right, there is a grid of blue rectangular icons each representing one of the option in the navigation tab, but with an icon and text representing metrics about that option." width=500>
  </a>
</p>


## Utilities

1. libvirt-clients

    This utility will audit a host machine and report what virtualisation capabilities are available

    - Installation

        ```bash
        sudo apt-get install -y libvirt-clients
        ```

    - Usage

        ```console
        $ virt-host-validate qemu
        QEMU: Checking for hardware virtualization          : PASS
        QEMU: Checking if device /dev/kvm exists            : PASS
        QEMU: Checking if device /dev/kvm is accessible     : PASS
        QEMU: Checking if device /dev/vhost-net exists      : PASS
        QEMU: Checking if device /dev/net/tun exists        : PASS
        ```

2. virtctl

    virtctl is the command-line utility for managing Kubevirt resources. It can be installed as a standalone CLI or as a Kubectl plugin via krew.

    - Standalone

        ```bash
        export VERSION=v0.41.0
        wget https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-linux-amd64
        ```

    - Plugin

        ```bash
        kubectl krew install virt
        ```

## Uninstall

In the event that Kubevirt does not uninstall gracefully, you may need to perform the following steps:

```bash
export RELEASE=v0.17.0

# --wait=true should anyway be default
kubectl delete -n kubevirt kubevirt kubevirt --wait=true

# this needs to be deleted to avoid stuck terminating namespaces
kubectl delete apiservices v1.subresources.kubevirt.io

# not blocking but would be left over
kubectl delete mutatingwebhookconfigurations virt-api-mutator

# not blocking but would be left over
kubectl delete validatingwebhookconfigurations virt-operator-validator

# not blocking but would be left over
kubectl delete validatingwebhookconfigurations virt-api-validator

kubectl delete -f https://github.com/kubevirt/kubevirt/releases/download/${RELEASE}/kubevirt-operator.yaml --wait=false
```


# Kubevirt Disks

Disk management is a critical part of Kubevirt operations. There are many types of disks and many ways to create them. Which type/method is best will depend entirely upon your use-case. For example, Kubevirt only supports live-migration and snapshot backups when disks are created using the `ReadWriteMany` StorageClass.

## Standard PVC Disks

Defining disks a PVCs is the most common way to create disks in Kubevirt. PVCs can hold cloud-images, ISO files, full machine snapshots and more. However, once you have attached a PVC to a VM, any changes to the data inside the PVC is permanent.

Standard PVC disks may not be ideal when creating multiple VMs since you would need to re-download the image file and create a whole new PVC each time you create a new VM. </br></br>

A standard PVC disk manifest:

```yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: debian12-pvc
  labels:
    app: containerized-data-importer
  annotations:
    cdi.kubevirt.io/storage.bind.immediate.requested: "true"
    cdi.kubevirt.io/storage.import.endpoint: "https://cloud.debian.org/images/cloud/bookworm/daily/latest/debian-12-generic-amd64-daily.qcow2"
spec:
  storageClassName: local-path
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 32Gi
```

## DataVolumes

DataVolumes are a shortcut for creating new PVC disks. Instead of mounting the PVC directly to the VM, a DataVolume manifest tells the CDI to first create a unique copy of the target PVC. This copy will then be mounted to the VM leaving the original unchanged. DataVolumes can be sourced from PVCs in other namespaces and also be re-sized before mounting.

While DataVolumes can avoid the cost of downloading and converting the image, there is a copy action that takes place during their creation which takes some time depending on your disk speed and the image size.

In addition to the above, DataVolumes can also be created from HTTP, S3, and OCI targets. While that is not any faster than using a standard PVC workflow, it does save quite a few lines of code.</br></br>

A manifest for DataVolume which copies a PVC:

```yaml
---
# The datavolume is the VM's harddrive
apiVersion: cdi.kubevirt.io/v1alpha1
kind: DataVolume
metadata:
  name: vm0-dv
  namespace: vm0
spec:
  source:
    pvc:
      namespace: default
      name: debian12-pvc
  pvc:
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 120Gi
```

## Ephemeral Disks

Ephemeral disks are similar to a DataVolumes in that they create a unique copy of an image, however they do not provide any persistence and are deleted upon termination of the VM. Without the backing of a PVC there is no copy action at instantiation time which makes ephemeral disks very fast to create.

Ephemeral disks are great for use with VM Pools, CICD Runners, and other use-cases which do not require persistence beyond the life-cycle of the workload.

- 

## Pre-Creating Images

For users who want their VM to be created as quickly as possible, the best option is to pre-create any disks you may need prior to creating a VM. This negates the need to wait for images to download and be converted before the VM can start (30-60 seconds). Images can either be manually uploaded to the CDI or defined as manifests for the CDI to consume.


1. Below we will pre-create a PVC which contains a cloud-image by downloading the image locally, and then pushing it to the CDI within our cluster.


    ```bash
    export VOLUME_NAME=debian12-pvc
    export NAMESPACE="default"
    export STORAGE_CLASS="local-path"
    export ACCESS_MODE="ReadWriteOnce"
    export IMAGE_URL="https://cloud.debian.org/images/cloud/bookworm/daily/latest/debian-12-generic-amd64-daily.qcow2"
    export IMAGE_PATH=debian-12-generic-amd64-daily.qcow2
    export VOLUME_TYPE=pvc
    export SIZE=32Gi
    export PROXY_ADDRESS=$(kubectl get svc cdi-uploadproxy -n cdi -o json | jq --raw-output '.spec.clusterIP')
    
    time wget -O $IMAGE_PATH $IMAGE_URL && \
    time virtctl image-upload $VOLUME_TYPE $VOLUME_NAME \
        --size=$SIZE \
        --image-path=$IMAGE_PATH \
        --uploadproxy-url=https://$PROXY_ADDRESS:443 \
        --namespace=$NAMESPACE \
        --storage-class=$STORAGE_CLASS \
        --access-mode=$ACCESS_MODE \
        --insecure --force-bind
    ```

2. The same process can also be used with ISO images which we would like to use as boot-media for VMs

    ```bash
    export VOLUME_NAME="windows10-iso-pvc"
    export NAMESPACE="default"
    export STORAGE_CLASS="local-path"
    export ACCESS_MODE="ReadWriteOnce"
    export IMAGE_URL="https://www.itechtics.com/?dl_id=173"
    export IMAGE_PATH="Win10_22H2_EnglishInternational_x64.iso"
    export VOLUME_TYPE="pvc"
    export SIZE="8Gi"
    export PROXY_ADDRESS=$(kubectl get svc cdi-uploadproxy -n cdi -o json | jq --raw-output '.spec.clusterIP')
    
    time wget -O $IMAGE_PATH $IMAGE_URL && \
    time virtctl image-upload $VOLUME_TYPE $VOLUME_NAME \
        --size=$SIZE \
        --image-path=$IMAGE_PATH \
        --uploadproxy-url=https://$PROXY_ADDRESS:443 \
        --namespace=$NAMESPACE \
        --storage-class=$STORAGE_CLASS \
        --access-mode=$ACCESS_MODE \
        --insecure --force-bind
    ```

3. In this example we define the same Debian12 cloud-image as in the first example, except this time we define it as a manifest which the CDI can consume directly.

    ```yaml
    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: "debian12"
      labels:
        app: containerized-data-importer
      annotations:
        cdi.kubevirt.io/storage.bind.immediate.requested: "true"
        cdi.kubevirt.io/storage.import.endpoint: "https://cloud.debian.org/images/cloud/bookworm/daily/latest/debian-12-generic-amd64-daily.qcow2"
    spec:
      storageClassName: local-path
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 32Gi
    ```

## Creation at Runtime

Disks can also be created at runtime via a manifest. This will trigger the CDI to download the image and convert it to a PVC before starting the VM. It is more convenient than manually pre-creating the image but increases the time a user must wait before their VM is ready.

- In the following example we define the disk and a VM as manifests which will be applied at the same time. The VM will not start until the cloud-image has been downloaded and written to a PVC.


    ```yaml
    # The PVC holds the original copy of the cloud-image
    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: debian12
      labels:
        app: containerized-data-importer
      annotations:
        cdi.kubevirt.io/storage.bind.immediate.requested: "true"
        cdi.kubevirt.io/storage.import.endpoint: "https://cloud.debian.org/images/cloud/bookworm/daily/latest/debian-12-generic-amd64-daily.qcow2"
    spec:
      storageClassName: local-path
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 32Gi
    ---
    # Create the VM
    apiVersion: kubevirt.io/v1
    kind: VirtualMachine
    metadata:
      generation: 1
      labels:
        kubevirt.io/os: linux
        metallb-service: vm0
      name: vm0
    spec:
      runStrategy: "RerunOnFailure"
      template:
        metadata:
          creationTimestamp: null
          labels:
            kubevirt.io/domain: vm0
            metallb-service: vm0
        spec:
          domain:
            cpu:
              sockets: 1
              cores: 2
              threads: 1
            firmware:
              bootloader:
                efi: {}
            devices:
              autoattachPodInterface: true
              autoattachSerialConsole: true
              autoattachGraphicsDevice: true
              disks:
              - name: harddrive
                disk:
                  bus: virtio
                bootOrder: 2
              - name: cloudinitvolume
                cdrom:
                  bus: sata
                  readonly: true
                bootOrder: 1
              interfaces:
                - masquerade: {}
                  name: default
            machine:
              type: q35
            resources:
              limits:
                memory: 2Gi
          networks:
          - name: default
            pod: {}
          volumes:
            - name: harddrive
              persistentVolumeClaim:
                claimName: debian12
            - name: cloudinitvolume
              cloudInitNoCloud:
                userData: |
                  #cloud-config
                  hostname: debian
                  ssh_pwauth: True
                  disable_root: false
                  users:
                   - name: friend
                     groups: users, admin, sudo
                     sudo: ALL=(ALL) NOPASSWD:ALL
                     shell: /bin/bash
                     lock_passwd: false
                     passwd: "$6$rounds=4096$saltsaltlettuce$Lp/FV.2oOgew7GbM6Nr8KMGMBn7iFM0x9ZwLqtx9Y4QJmKvfcnS.2zx4MKmymCPQGpHS7gqYOiqWjvdCIV2uN."
    ```
