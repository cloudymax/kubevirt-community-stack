<h1 align=center>
Kubevirt Community Stack
</h1>
<p align="center">
  <img width="64" src="https://avatars.githubusercontent.com/u/18700703?s=200&v=4">
</p>
<p align=center>
  Create Kubevirt VMs via Helm <br>
  for use with <a href="https://argoproj.github.io/cd/">ArgoCD</a>, <a href="https://argoproj.github.io/workflows/">Argo Workflows</a>, <a href="https://keda.sh/">KEDA</a>, <a href="https://cluster-api.sigs.k8s.io/">ClusterAPI</a>, <a href="https://github.com/kubevirt/kubevirt-tekton-tasks?tab=readme-ov-file">Tekton</a> etc...
  <br>
  <br>
</p>
<br>

## Who is this for:

The Kubevirt-Community-Stack may be of interest if you:
- operate one or more physical computers which you would like to split into smaller virtual machiens.
- are already running kubernetes to orchestrate container workloads
- are already in the <a href="https://argoproj.github.io/cd/">ArgoCD</a> or <a href="https://github.com/kubevirt/kubevirt-tekton-tasks?tab=readme-ov-file">Tekton</a> ecosystem and/or work primarily with some other Helm-based tooling.
- want/need fully-featured VMs for hardware emulation, hardware-passthrough, Virtual Desktops, vGPU which are not suppoted by Micro-VMs like <a href="https://firecracker-microvm.github.io/">Firecracker</a>
- want to integrate Kubevirt into your existing infrastructure without needing to adopt a full platform like <a href="https://www.redhat.com/en/technologies/cloud-computing/openshift/virtualization">OpenShift Virtuazation</a>, <a href="https://harvesterhci.io/">HarvesterHCI</a>, <a href="https://www.starlingx.io/">StarlingX</a>, or <a href="">KubeSphere</a> etc...
- want to install and operate Kubevirt on an existing system withhout needing to re-image it with an installer ISO.


## Component charts

<details>
  <summary>Kubervirt</summary>
  <br>
  <a href="https://github.com/kubevirt/kubevirt">Kubevirt</a> is a Kubernetes Virtualization API and runtime which controls QEMU/KVM virtual machine instances and provides the CRDs that define them. It's distrubuted as a Kubernetes Operator which is install via the <a href="https://github.com/kubevirt/kubevort">kubevirt</a> chart.
  <br>
  <br>
</details>

<details>
  <summary>Kubevirt CDI</summary>
  <br>
  The <a href="https://github.com/kubevirt/containerized-data-importer">Containerized Data Importer</a> can pull virtual machine images, ISO files, and other types of bootable media from sources like S3, HTTP, or OCI images. This data is then written to PVCs which are mounted as disks. For examples of various ways to use the CDI, see the notes in <a href="https://github.com/small-hack/argocd-apps/blob/main/kubevirt/examples/disks/Disks.md">Argocd-Apps</a>
  <br>
  <br>
</details>

<details>
  <summary>Cloud-Init</summary>
  <br>
  The <a href="https://github.com/cloudymax/kubevirt-community-stack/tree/main/charts/cloud-init">Cloud-init helm chart</a> allows the user to define the specification of a linux-based vm's operating system as code. In addition to basec cloud-init functions, his chart provides some extra functionality via an initjob that makes cloud-init more GitOps friendly.
  <br>
  <br>
Additional Features:

  - Regex values using existing secrets or environmental variables via envsubst
  - Create random user passwords or use an existing secret
  - Download files from a URL
  - Base64 encode + gzip your `write_files` content
  - Populate Wireguard configuration values from an existsing secret
  - Track the total size of user-data and check file for valid syntax
  <br>
  <br>
</details>

<details>
  <summary>Kubevirt VM</summary>
  <br>
  The <a href="https://github.com/cloudymax/kubevirt-community-stack/tree/main/charts/kubevirt-vm">Kubevirt-VM Chart</a> allows a user to easily template a Kubevirt VirtualMachine or VirtualMachinePool and its associated resources sudch as Disks, DataVolumes, Horizontal Pod Autoscaler, Network Policies, Service, Ingres, Probes, and Cloud-init data (via bundled cloud-init subchart).
  <br>
  <br>
</details>

<details>
  <summary>Kubevirt Manager</summary>
  <br>
      This is a community-developed web-ui which allows users to create, manage, and interact with virtual machines running in Kubevirt. See their official docs at <a href="https://kubevirt-manager.io/">kubevirt-manager.io</a>
  <br>
  <br>

  <p align="center">
  <a href="https://github.com/cloudymax/kubevirt-community-stack/assets/84841307/eeb87969-4dd6-49ce-b25e-37404e05fa72">
      <img src="https://github.com/cloudymax/kubevirt-community-stack/assets/84841307/eeb87969-4dd6-49ce-b25e-37404e05fa72" alt="Screenshot showing the default page of Kubevirt-manager. The screen is devided into 2 sections. On the left, there is a vertical navigation tab with a grey background. The options in this bar are Dashboard, Virtual Machines, VM Pools, Auto Scaling, Nodes, Data Volumes, Instance Types, and Load Balancers.  On the right, there is a grid of blue rectangular icons each representing one of the option in the navigation tab, but with an icon and text representing metrics about that option." width=500>
  </a>
  </p>
  <br>
  <br>
</details>

<details>
  <summary>Cluster API Operator & Addons</summary>
  <br>
   <a href="https://cluster-api.sigs.k8s.io/">Cluster API</a> provides a standardised kubernetes-native interface for creating k8s clusters using a wide variety of providers. The combined chart can install the <a href="https://cluster-api-operator.sigs.k8s.io/">Cluster API Operator</a> as well as bootstrap the <a href="https://github.com/kubernetes-sigs/cluster-api-provider-kubevirt">Cluster API Kubevirt Provider</a> which allows creating k8s clusters from the CLI or as YAML using Kubevirt VMs. Cluster-api-provider-kubevirt also includes <a href="https://github.com/kubevirt/cloud-provider-kubevirt">cloud-provider-kubevirt</a> which enables the exposeure of LoadBalancer type services within tenant clusters to the host cluster. This negates the need for a dedicated loadbalancer such as <a href="https://metallb.io/">MetalLB</a> inside the tenant cluster.
  <br>
  <br>
See <a href="https://github.com/cloudymax/kubevirt-community-stack/blob/main/CAPI.md">CAPI.md</a> for a basic walkthrough of creating a CAPI-based tenant cluster.
  <br>
  <br>
</details>

<details>
  <summary>CAPI Cluster</summary>
  <br>
  The CAPI Cluster helm chart provides a way to create workload clusters using the Kubevirt infrastructure, Kubeadm Bootstrap + ControlPlane, and Helm providers.
  <br>
  <br>
</details>


## Dependencies

<details>
  <summary>libvirt-clients</summary><br>
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
</details>

<details>
  <summary>virtctl</summary><br>
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
</details>

<details>
  <summary>clusterctl</summary><br>
  The clusterctl CLI tool handles the lifecycle of a Cluster API management cluster.

  ```bash
  curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v1.7.2/clusterctl-linux-amd64 -o clusterctl
  sudo install -o root -g root -m 0755 clusterctl /usr/local/bin/clusterctl
  ```
</details>


##  Install The Kubevirt-Community-Stack

- Install the combined chart (<a href="https://github.com/cloudymax/kubevirt-charts/blob/main/charts/kubevirt-stack">kubevirt-stack</a>).
   ```bash
    helm repo add kubevirt https://cloudymax.github.io/kubevirt-community-stack
    helm install kubevirt-stack kubevirt/kubevirt-stack \
      --namespace kubevirt \
      --create-namespace
    ```

<details>
  <summary>Expand to see individual chart installation</summary>
<br>

- <a href="https://github.com/cloudymax/kubevirt-community-stack/blob/main/charts/kubevirt">kubevirt</a>: Installs the Kubevirt Operator.

    ```bash
    helm repo add kubevirt https://cloudymax.github.io/kubevirt-community-stack
    helm install kubevirt kubevirt/kubevirt \
      --namespace kubevirt \
      --create-namespace
    ```

- <a href="https://github.com/cloudymax/kubevirt-community-stack/blob/main/charts/cluster-api-operator">Cluster API Operator</a>: Installs the Cluster API Operator.

    ```bash
    Work in progress.
    ```

- <a href="https://github.com/cloudymax/kubevirt-community-stack/blob/main/charts/kubevirt-cdi">kubevirt-cdi</a>: Install the Containerized Data Importer.

    ```bash
    helm repo add kubevirt https://cloudymax.github.io/kubevirt-community-stack
    helm install kubevirt-cdi kubevirt/kubevirt-cdi \
      --namespace cdi \
      --create-namespace
    ```

- <a href="https://github.com/cloudymax/kubevirt-community-stack/blob/main/charts/kubevirt-manager">kubevirt-manager</a>: Deploy the Kubevirt-Manager UI

    ```bash
    # Customize your own values.yaml before deploying
    helm repo add kubevirt https://cloudymax.github.io/kubevirt-charts
    helm install kubevirt-manager kubevirt/kubevirt-manager \
      --fnamespace kubevirt-manager \
      --create-namespace
    ```
</details>

## Creating a VM

This is a qucik walkthrough of how I create VMs using kubevirt-community-stack. All the configuration for the VM happens in the `values.yaml` file of the <a href="https://github.com/cloudymax/kubevirt-community-stack/tree/main/charts/kubevirt-vm">Kubevirt-VM Chart</a>  chart.

From this file we can configure the VM, Disks, Cloudinit config, services, probes and more.

> With the command or file below we will:
>   1. Create a new VM named `example` with with `2` cores and `2Gi` of RAM.
>   2. Create a `16Gi` PVC named `harddrive` which holds a debian12 cloud-image.
>   3. Define a user named `example` and assign the user some groups and a random password which will be stored in a secret.
>   4. Save our user-data as a secret named `example-user-data`
>   5. Update apt-packes and install docker.
>   6. Run the nginx docker container with port `8080` exposed from the container to the VM
>   7. Define a service over which to expose port `8080` from the VM to the host.

<details>
<summary>Requirements</summary>
<br>

- you are running on bare-metal, not inside a VM
	
- you set `cpuManagerPolicy: static` in your kubelet config
 
- you have `yq` and either `virtctl` or `krew virt` installed

- your host system passes all `virt-host-validate qemu` checks for KVM
	
  ```console
  QEMU: Checking for hardware virtualization                                 : PASS
  QEMU: Checking if device /dev/kvm exists                                   : PASS
  QEMU: Checking if device /dev/kvm is accessible                            : PASS
  ```
</details>

<details>
<summary>Command Line method:</summary>

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

</details>


<details>
<summary>Values File method:</summary>

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
```

- Install VM as a helm-chart (or template it out as manifests):

    ```bash
    helm install example kubevirt/kubevirt-vm \
      --namespace kubevirt \
      --create-namespace \
      -f example.yaml
    ```
</details>

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

# Find hanging resources
kubectl api-resources --verbs=list --namespaced -o name   | xargs -n 1 kubectl get --show-kind --ignore-not-found -n kubevirt

# If namespace is stuck
kubectl get namespace "kubevirt" -o json   | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/"   | kubectl replace --raw /api/v1/namespaces/kubevirt/finalize -f -
```
