# cluster-api-operator

![Version: 2.0.0](https://img.shields.io/badge/Version-2.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.24.0](https://img.shields.io/badge/AppVersion-v0.24.0-informational?style=flat-square)

Cluster API Operator

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| "manager.featureGates" | object | `{}` |  |
| addon.helm.createNamespace | bool | `false` |  |
| addon.helm.namespace | string | `"default"` |  |
| addon.helm.version | string | `"v0.4.1"` |  |
| affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key | string | `"kubernetes.io/arch"` |  |
| affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator | string | `"In"` |  |
| affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[0] | string | `"amd64"` |  |
| affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[1] | string | `"arm64"` |  |
| affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[2] | string | `"ppc64le"` |  |
| affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[1].key | string | `"kubernetes.io/os"` |  |
| affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[1].operator | string | `"In"` |  |
| affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[1].values[0] | string | `"linux"` |  |
| bootstrap.k3s.createNamespace | bool | `false` |  |
| bootstrap.k3s.fetchConfig.url | string | `"https://github.com/k3s-io/cluster-api-k3s/releases/v0.2.1/bootstrap-components.yaml"` |  |
| bootstrap.k3s.namespace | string | `"default"` |  |
| bootstrap.k3s.version | string | `"v0.3.0"` |  |
| bootstrap.kubeadm.createNamespace | bool | `false` |  |
| bootstrap.kubeadm.namespace | string | `"default"` |  |
| bootstrap.kubeadm.version | string | `"v1.11.2"` |  |
| bootstrap.rke2.createNamespace | bool | `false` |  |
| bootstrap.rke2.namespace | string | `"default"` |  |
| bootstrap.rke2.version | string | `"v0.21.0"` |  |
| configSecret | object | `{}` | - Common configuration secret options |
| containerSecurityContext | object | `{}` |  |
| contentionProfiling | bool | `false` |  |
| controlPlane.k3s.createNamespace | bool | `false` |  |
| controlPlane.k3s.fetchConfig.url | string | `"https://github.com/k3s-io/cluster-api-k3s/releases/v0.2.1/control-plane-components.yaml"` |  |
| controlPlane.k3s.namespace | string | `"default"` |  |
| controlPlane.k3s.version | string | `"v0.2.1"` |  |
| controlPlane.kubeadm.createNamespace | bool | `false` |  |
| controlPlane.kubeadm.namespace | string | `"default"` |  |
| controlPlane.kubeadm.version | string | `"v1.11.2"` |  |
| controlPlane.rke2.createNamespace | bool | `false` |  |
| controlPlane.rke2.namespace | string | `"default"` |  |
| controlPlane.rke2.version | string | `"v0.20.1"` |  |
| core | object | `{"cluster-api":{"createNamespace":true,"namespace":"capi-system","version":"v1.11.2"}}` | - Cluster API provider options |
| diagnosticsAddress | string | `":8443"` |  |
| enableHelmHook | bool | `false` |  |
| env.manager | list | `[]` |  |
| fetchConfig | object | `{}` |  |
| healthAddr | string | `":9440"` |  |
| image.manager.pullPolicy | string | `"IfNotPresent"` |  |
| image.manager.repository | string | `"gcr.io/k8s-staging-capi-operator/cluster-api-operator"` |  |
| image.manager.tag | string | `""` | defaults to appVersion |
| imagePullSecrets | object | `{}` |  |
| infrastructure.kubevirt.createNamespace | bool | `false` |  |
| infrastructure.kubevirt.namespace | string | `"default"` |  |
| infrastructure.kubevirt.version | string | `"v0.1.10"` |  |
| insecureDiagnostics | bool | `false` |  |
| ipam.in-cluster.createNamespace | bool | `false` |  |
| ipam.in-cluster.namespace | string | `"default"` |  |
| ipam.in-cluster.version | string | `"v1.0.3"` |  |
| leaderElection.enabled | bool | `true` |  |
| logLevel | int | `2` | - CAPI operator deployment options |
| profilerAddress | string | `":6060"` |  |
| replicaCount | int | `1` |  |
| resources.manager.limits.cpu | string | `"100m"` |  |
| resources.manager.limits.memory | string | `"300Mi"` |  |
| resources.manager.requests.cpu | string | `"100m"` |  |
| resources.manager.requests.memory | string | `"100Mi"` |  |
| tolerations[0].effect | string | `"NoSchedule"` |  |
| tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| tolerations[1].effect | string | `"NoSchedule"` |  |
| tolerations[1].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| volumeMounts.manager[0].mountPath | string | `"/tmp/k8s-webhook-server/serving-certs"` |  |
| volumeMounts.manager[0].name | string | `"cert"` |  |
| volumeMounts.manager[0].readOnly | bool | `true` |  |
| volumes[0].name | string | `"cert"` |  |
| volumes[0].secret.defaultMode | int | `420` |  |
| volumes[0].secret.secretName | string | `"capi-operator-webhook-service-cert"` |  |
| watchConfigMap | bool | `false` |  |
| watchConfigSecret | bool | `false` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
