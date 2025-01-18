# Creating a CAPI Cluster

Creating a CAPI Cluster is quite easy thanks to the [cluster-api-cluster](https://github.com/cloudymax/kubevirt-community-stack/tree/main/charts/capi-cluster) helm chart.

Install a cluster named "capi"

```bash
helm install capi kubevirt/cluster-api-cluster \
	--set "cluster.name=capi" \
	--set "MachineTemplates.controlPlane.size=1"
	--set "MachineTemplates.workers.size=2"
```

Use clusterctl to get the kubeconfig from a secret

```bash
clusterctl get kubeconfig capi > capi.kubeconfig
```

Check on the new cluster using kubectl

```bash
kubectl get nodes --kubeconfig=capi.kubeconfig
```
