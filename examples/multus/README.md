# Multus

Multus CNI is a container network interface (CNI) plugin for Kubernetes that enables attaching multiple network interfaces to pods. It is a "Meta" plugin that does not function on its own - rather it orchestrates the behavior of multiple other CNI plugins. This allows the creation of multiple network interfaces in a single pod. 

In this guide will limit the scope to the configuration of Multus with the [macvlan](https://www.cni.dev/plugins/current/main/macvlan/), [bridge](https://www.cni.dev/plugins/current/main/bridge/), and [IPAM](https://www.cni.dev/plugins/current/ipam/) CNI plugins. For Additional information please consult the [Multus Docs](https://github.com/k8snetworkplumbingwg/multus-cni/tree/master/docs) and [CNI Plugins References](https://www.cni.dev/plugins/current/).


![multus-pod-image](https://github.com/k8snetworkplumbingwg/multus-cni/blob/master/docs/images/multus-pod-image.svg)

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

## Usage

Multus uses a `NetworkAttachmentDefinition` CRD to define how to attach networks to pods.  

