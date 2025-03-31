# Multus

Multus CNI is a container network interface (CNI) plugin for Kubernetes that enables attaching multiple network interfaces to pods. 

- https://github.com/k8snetworkplumbingwg/multus-cni
- https://www.cni.dev/plugins/current/

## Installation

This project uses RKE2 & K3s as its primary Kubernetes distributions, both of which provides a native wat to deploy Multus via the `cni` section of the RKE2/K3s config file.

```yaml
cni:
  - multus
  - cilium
```

RKE2 Additionally provides a helm-chart for Multus through which the DHCP daemon my be deployed.

```yaml
---
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: rke2-multus
  namespace: kube-system
spec:
  valuesContent: |-
    manifests:
      dhcpDaemonSet: true
```

> [!WARNING] 
> When recreating a cluster where the DHCP Daemon has been deployed, you must reboot the node prior to recreating the cluster to fully disable to prior DHCP Daemon deployment.



