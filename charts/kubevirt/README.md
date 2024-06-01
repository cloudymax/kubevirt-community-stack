# kubevirt

![Version: 0.2.4](https://img.shields.io/badge/Version-0.2.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.2.0](https://img.shields.io/badge/AppVersion-v1.2.0-informational?style=flat-square)

Deploy Kebivirt on Kubernetes

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cloudymax |  | <https://github.com/cloudymax/> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://kubernetes-sigs.github.io/cluster-api-operator | cluster-api-operator | v0.10.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchExpressions":[{"key":"kubevirt.io","operator":"In","values":["virt-operator"]}]},"topologyKey":"kubernetes.io/hostname"},"weight":1}]}}` | by default forces replicas to different knodes |
| cluster-api-operator."manager.featureGates" | object | `{}` |  |
| cluster-api-operator.addon | string | `""` |  |
| cluster-api-operator.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key | string | `"kubernetes.io/arch"` |  |
| cluster-api-operator.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator | string | `"In"` |  |
| cluster-api-operator.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[0] | string | `"amd64"` |  |
| cluster-api-operator.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[1] | string | `"arm64"` |  |
| cluster-api-operator.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[2] | string | `"ppc64le"` |  |
| cluster-api-operator.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[1].key | string | `"kubernetes.io/os"` |  |
| cluster-api-operator.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[1].operator | string | `"In"` |  |
| cluster-api-operator.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[1].values[0] | string | `"linux"` |  |
| cluster-api-operator.bootstrap | string | `""` |  |
| cluster-api-operator.configSecret | object | `{}` | - Common configuration secret options |
| cluster-api-operator.containerSecurityContext | object | `{}` |  |
| cluster-api-operator.controlPlane | string | `""` |  |
| cluster-api-operator.core | string | `""` |  |
| cluster-api-operator.diagnosticsAddress | string | `"8443"` |  |
| cluster-api-operator.enabled | bool | `false` |  |
| cluster-api-operator.env.manager | list | `[]` |  |
| cluster-api-operator.healthAddr | string | `":8081"` |  |
| cluster-api-operator.image.manager.pullPolicy | string | `"IfNotPresent"` |  |
| cluster-api-operator.image.manager.repository | string | `"gcr.io/k8s-staging-capi-operator/cluster-api-operator"` |  |
| cluster-api-operator.image.manager.tag | string | `"dev"` |  |
| cluster-api-operator.imagePullSecrets | object | `{}` |  |
| cluster-api-operator.infrastructure | string | `"kubevirt"` |  |
| cluster-api-operator.insecureDiagnostics | bool | `false` |  |
| cluster-api-operator.leaderElection.enabled | bool | `true` |  |
| cluster-api-operator.logLevel | int | `2` | - CAPI operator deployment options |
| cluster-api-operator.metricsBindAddr | string | `"127.0.0.1:8080"` |  |
| cluster-api-operator.replicaCount | int | `1` |  |
| cluster-api-operator.resources.manager.limits.cpu | string | `"100m"` |  |
| cluster-api-operator.resources.manager.limits.memory | string | `"150Mi"` |  |
| cluster-api-operator.resources.manager.requests.cpu | string | `"100m"` |  |
| cluster-api-operator.resources.manager.requests.memory | string | `"100Mi"` |  |
| cluster-api-operator.tolerations[0].effect | string | `"NoSchedule"` |  |
| cluster-api-operator.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| cluster-api-operator.tolerations[1].effect | string | `"NoSchedule"` |  |
| cluster-api-operator.tolerations[1].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| cluster-api-operator.volumeMounts.manager[0].mountPath | string | `"/tmp/k8s-webhook-server/serving-certs"` |  |
| cluster-api-operator.volumeMounts.manager[0].name | string | `"cert"` |  |
| cluster-api-operator.volumeMounts.manager[0].readOnly | bool | `true` |  |
| cluster-api-operator.volumes[0].name | string | `"cert"` |  |
| cluster-api-operator.volumes[0].secret.defaultMode | int | `420` |  |
| cluster-api-operator.volumes[0].secret.secretName | string | `"capi-operator-webhook-service-cert"` |  |
| featureGates[0] | string | `"ExpandDisks"` |  |
| featureGates[10] | string | `"clientPassthrough"` |  |
| featureGates[11] | string | `"Snapshot"` |  |
| featureGates[12] | string | `"CPUNodeDiscovery"` |  |
| featureGates[1] | string | `"CPUManager"` |  |
| featureGates[2] | string | `"GPU"` |  |
| featureGates[3] | string | `"HostDevices"` |  |
| featureGates[4] | string | `"VMExport"` |  |
| featureGates[5] | string | `"HotplugVolumes"` |  |
| featureGates[6] | string | `"HostDisk"` |  |
| featureGates[7] | string | `"Macvtap"` |  |
| featureGates[8] | string | `"Passt"` |  |
| featureGates[9] | string | `"HotplugNICs"` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| image.repository | string | `"quay.io/kubevirt/virt-operator"` | container repository |
| image.tag | string | `"v1.2.0"` | image tag, use this to set the version of kubevirt |
| imagePullSecrets | list | `[]` |  |
| mediatedDevicesTypes | list | `[]` |  |
| monitorAccount | string | `""` |  |
| monitorNamespace | string | `""` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| permittedHostDevices.mediatedDevices | list | `[]` |  |
| permittedHostDevices.pciHostDevices | list | `[]` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| priorityclass.create | bool | `true` | craete priorityclass by default |
| priorityclass.value | int | `1000000000` | default priorityclass value |
| replicaCount | int | `1` | number of replicas |
| resources | object | `{}` |  |
| securityContext.privileged | bool | `true` | sets the container to privileged |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `"kubevirt-operator"` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[{"key":"CriticalAddonsOnly","operator":"Exists"}]` | toleration for CriticalAddonsOnly |
| useEmulation | bool | `false` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
