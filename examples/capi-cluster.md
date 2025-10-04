# Creating a CAPI Cluster

Creating a CAPI Cluster is quite easy thanks to the [cluster-api-cluster](https://github.com/cloudymax/kubevirt-community-stack/tree/main/charts/capi-cluster) helm chart.

1. Install a cluster named "capi" with 1 control-plane node and 2 workers.

	```bash
	helm install capi kubevirt/cluster-api-cluster \
	--set "cluster.name=capi" \
	--set "MachineTemplates.controlPlane.size=1" \
	--set "MachineTemplates.workers.size=2"
	```

2. Use clusterctl to get the kubeconfig from a secret

	```bash
	clusterctl get kubeconfig capi > capi.kubeconfig
	```

3. Check on the new cluster using kubectl

	```bash
	watch kubectl get nodes --kubeconfig=capi.kubeconfig
	```

## Single Node Clusters

It is also possible to create a single-node cluster, but make sure you apply the correct tolerations where required. 

Example toleration:

```yaml
tolerations:
  - key: "node-role.kubernetes.io/control-plane"
  operator: "Exists"
  effect: "NoSchedule"
```

## Mounting a secondary disk as k3s/rke2 data-dir

You cant specify the data-dir with the k3s/rke2 providers so if you want to change it you have to mount a disk like this:

```yaml
spec:
  kthreesConfigSpec:
    preK3sCommands:
      - mkdir -p /etc/kubernetes
      - mkdir -p /var/lib/rancher/k3s/storage
      - printf 'o\nn\np\n1\n\n\nw' | fdisk /dev/vdb
      - sudo mkfs.ext4 /dev/vdb1
      - sudo mount /dev/vdb1 /var/lib/rancher/k3s/storage
      - sudo chmod -R 777 /var/lib/rancher/k3s/storage
      - ls -hal /var/lib/rancher/k3s
      - printf '/dev/vdb1 /var/lib/rancher/k3s/storage ext4 defaults,nofail,discard 0 0' >> /etc/fstab
```
