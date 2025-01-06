# cluster-api-cluster

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.0](https://img.shields.io/badge/AppVersion-0.0.0-informational?style=flat-square)

Cluster API Cluster using Kubevirt and Kubeadm

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| MachineTemplates.controlPlane | object | `{"cores":2,"cpuModel":"host-passthrough","disk":"32Gi","memory":"4Gi","size":1}` | Control Plane VM pool spec |
| MachineTemplates.workers | object | `{"cores":4,"cpuModel":"host-passthrough","disk":"32Gi","memory":"8Gi","size":2}` | Worker VM spec |
| cluster.controlPlaneServiceType | string | `"ClusterIP"` | Type of service to use when exposing control plane endpoint on Host |
| cluster.disableKubeProxy | bool | `false` | Disable the deployment of kube-proxy |
| cluster.dnsDomain | string | `"cluster.local"` | Cluster internal DNS domain |
| cluster.kubeletExtraArgs | object | `{"eviction-hard":"memory.available<500Mi,nodefs.available<10%","kube-reserved":"cpu=1,memory=2Gi,ephemeral-storage=1Gi","system-reserved":"cpu=500m,memory=1Gi,ephemeral-storage=1Gi"}` | Extra args to pass to kubelet |
| cluster.name | string | `"capi"` | Name of the cluster to create |
| cluster.namespace | string | `"kubevirt"` | Namespace in which to host cluster components |
| cluster.podCidrBlock | string | `"10.243.0.0/16"` | CIDR block for pod network |
| cluster.serviceCidrBlock | string | `"10.95.0.0/16"` | CIDR block for services |
| cluster.version | string | `"v1.30.1"` | Version of kubernetes to deploy |
| helmCharts[0].metadata.name | string | `"clilum"` |  |
| helmCharts[0].metadata.namespace | string | `"kubevirt"` |  |
| helmCharts[0].name | string | `"cilium"` |  |
| helmCharts[0].spec.chartName | string | `"cilium"` |  |
| helmCharts[0].spec.namespace | string | `"kube-system"` |  |
| helmCharts[0].spec.options.install.createNamespace | bool | `true` |  |
| helmCharts[0].spec.options.wait | bool | `true` |  |
| helmCharts[0].spec.options.waitForJobs | bool | `true` |  |
| helmCharts[0].spec.repoURL | string | `"https://helm.cilium.io/"` |  |
| helmCharts[0].spec.valuesTemplate | string | `"operator:\n  replicas: 1\nhubble:\n  enabled: true\n  relay:\n    enabled: true\n  ui:\n    enabled: true"` |  |
| helmCharts[1].metadata.name | string | `"cert-manager"` |  |
| helmCharts[1].metadata.namespace | string | `"kubevirt"` |  |
| helmCharts[1].name | string | `"cert-manager"` |  |
| helmCharts[1].spec.chartName | string | `"cert-manager"` |  |
| helmCharts[1].spec.namespace | string | `"cert-manager"` |  |
| helmCharts[1].spec.options.install.createNamespace | bool | `true` |  |
| helmCharts[1].spec.repoURL | string | `"https://charts.jetstack.io"` |  |
| helmCharts[1].spec.valuesTemplate | string | `"crds:\n  enabled: true"` |  |
| helmCharts[1].spec.version | string | `"v1.16.2"` |  |
| helmCharts[2].metadata.name | string | `"ingress-nginx"` |  |
| helmCharts[2].metadata.namespace | string | `"kubevirt"` |  |
| helmCharts[2].name | string | `"ingress-nginx"` |  |
| helmCharts[2].spec.chartName | string | `"ingress-nginx"` |  |
| helmCharts[2].spec.namespace | string | `"ingress-nginx"` |  |
| helmCharts[2].spec.options.install.createNamespace | bool | `true` |  |
| helmCharts[2].spec.repoURL | string | `"https://kubernetes.github.io/ingress-nginx"` |  |
| helmCharts[2].spec.valuesTemplate | string | `"install:\n  createNamespace: true"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)