# kubevirt-stack

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.0](https://img.shields.io/badge/AppVersion-0.0.0-informational?style=flat-square)

Combined meta-chart for installing Kubevirt, its dependencies, and addons

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cloudymax | <emax@cloudydev.net> | <https://github.com/cloudymax/> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://cloudymax.github.io/kubevirt-community-stack | capi(cluster-api-operator) | 1.1.0 |
| https://cloudymax.github.io/kubevirt-community-stack | operator(kubevirt) | 0.4.0 |
| https://cloudymax.github.io/kubevirt-community-stack | cdi(kubevirt-cdi) | 0.3.0 |
| https://cloudymax.github.io/kubevirt-community-stack | manager(kubevirt-manager) | 0.3.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| capi."manager.featureGates" | object | `{}` |  |
| capi.addon.helm.createNamespace | bool | `false` |  |
| capi.addon.helm.namespace | string | `"default"` |  |
| capi.addon.helm.version | string | `"v0.4.1"` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key | string | `"kubernetes.io/arch"` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator | string | `"In"` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[0] | string | `"amd64"` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[1] | string | `"arm64"` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[2] | string | `"ppc64le"` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[1].key | string | `"kubernetes.io/os"` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[1].operator | string | `"In"` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[1].values[0] | string | `"linux"` |  |
| capi.bootstrap.k3s.createNamespace | bool | `false` |  |
| capi.bootstrap.k3s.fetchConfig.url | string | `"https://github.com/k3s-io/cluster-api-k3s/releases/v0.3.0/bootstrap-components.yaml"` |  |
| capi.bootstrap.k3s.namespace | string | `"default"` |  |
| capi.bootstrap.k3s.version | string | `"v0.3.0"` |  |
| capi.bootstrap.kubeadm.createNamespace | bool | `false` |  |
| capi.bootstrap.kubeadm.namespace | string | `"default"` |  |
| capi.bootstrap.kubeadm.version | string | `"v1.11.2"` |  |
| capi.bootstrap.rke2.createNamespace | bool | `false` |  |
| capi.bootstrap.rke2.namespace | string | `"default"` |  |
| capi.bootstrap.rke2.version | string | `"v0.21.0"` |  |
| capi.configSecret | object | `{}` |  |
| capi.containerSecurityContext | object | `{}` |  |
| capi.contentionProfiling | bool | `false` |  |
| capi.controlPlane.k3s.createNamespace | bool | `false` |  |
| capi.controlPlane.k3s.fetchConfig.url | string | `"https://github.com/k3s-io/cluster-api-k3s/releases/v0.3.0/control-plane-components.yaml"` |  |
| capi.controlPlane.k3s.namespace | string | `"default"` |  |
| capi.controlPlane.k3s.version | string | `"v0.3.0"` |  |
| capi.controlPlane.kubeadm.createNamespace | bool | `false` |  |
| capi.controlPlane.kubeadm.namespace | string | `"default"` |  |
| capi.controlPlane.kubeadm.version | string | `"v1.11.2"` |  |
| capi.controlPlane.rke2.createNamespace | bool | `false` |  |
| capi.controlPlane.rke2.namespace | string | `"default"` |  |
| capi.controlPlane.rke2.version | string | `"v0.20.1"` |  |
| capi.core.cluster-api.createNamespace | bool | `true` |  |
| capi.core.cluster-api.namespace | string | `"capi-system"` |  |
| capi.core.cluster-api.version | string | `"v1.11.2"` |  |
| capi.diagnosticsAddress | string | `":8443"` |  |
| capi.enableHelmHook | bool | `true` |  |
| capi.enabled | bool | `false` |  |
| capi.env.manager | list | `[]` |  |
| capi.fetchConfig | object | `{}` |  |
| capi.healthAddr | string | `":9440"` |  |
| capi.image.manager.pullPolicy | string | `"IfNotPresent"` |  |
| capi.image.manager.repository | string | `"gcr.io/k8s-staging-capi-operator/cluster-api-operator"` |  |
| capi.image.manager.tag | string | `"dev"` |  |
| capi.imagePullSecrets | object | `{}` |  |
| capi.infrastructure.kubevirt.createNamespace | bool | `false` |  |
| capi.infrastructure.kubevirt.namespace | string | `"default"` |  |
| capi.infrastructure.kubevirt.version | string | `"v0.1.10"` |  |
| capi.insecureDiagnostics | bool | `false` |  |
| capi.ipam.in-cluster.createNamespace | bool | `false` |  |
| capi.ipam.in-cluster.namespace | string | `"default"` |  |
| capi.ipam.in-cluster.version | string | `"v1.0.3"` |  |
| capi.leaderElection.enabled | bool | `true` |  |
| capi.logLevel | int | `2` | - CAPI operator deployment options |
| capi.profilerAddress | string | `":6060"` |  |
| capi.replicaCount | int | `1` |  |
| capi.resources.manager.limits.cpu | string | `"100m"` |  |
| capi.resources.manager.limits.memory | string | `"300Mi"` |  |
| capi.resources.manager.requests.cpu | string | `"100m"` |  |
| capi.resources.manager.requests.memory | string | `"100Mi"` |  |
| capi.tolerations[0].effect | string | `"NoSchedule"` |  |
| capi.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| capi.tolerations[1].effect | string | `"NoSchedule"` |  |
| capi.tolerations[1].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| capi.volumeMounts.manager[0].mountPath | string | `"/tmp/k8s-webhook-server/serving-certs"` |  |
| capi.volumeMounts.manager[0].name | string | `"cert"` |  |
| capi.volumeMounts.manager[0].readOnly | bool | `true` |  |
| capi.volumes[0].name | string | `"cert"` |  |
| capi.volumes[0].secret.defaultMode | int | `420` |  |
| capi.volumes[0].secret.secretName | string | `"capi-operator-webhook-service-cert"` |  |
| capi.watchConfigMap | bool | `false` |  |
| capi.watchConfigSecret | bool | `false` |  |
| cdi.affinity | object | `{}` |  |
| cdi.cdi.featureGates[0] | string | `"HonorWaitForFirstConsumer"` |  |
| cdi.cdi.resources.limits.cpu | string | `"4"` |  |
| cdi.cdi.resources.limits.memory | string | `"4Gi"` |  |
| cdi.cdi.resources.requests.cpu | string | `"1"` |  |
| cdi.cdi.resources.requests.memory | string | `"250Mi"` |  |
| cdi.image.pullPolicy | string | `"IfNotPresent"` |  |
| cdi.image.repository | string | `"quay.io/kubevirt/cdi-operator"` |  |
| cdi.image.tag | string | `""` |  |
| cdi.ingress.annotations | object | `{}` |  |
| cdi.ingress.className | string | `""` |  |
| cdi.ingress.enabled | bool | `false` |  |
| cdi.ingress.hosts[0].host | string | `"chart-example.local"` |  |
| cdi.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| cdi.ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| cdi.ingress.tls | list | `[]` |  |
| cdi.nodeSelector."kubernetes.io/os" | string | `"linux"` |  |
| cdi.replicaCount | int | `1` |  |
| cdi.resources.requests.cpu | string | `"10m"` |  |
| cdi.resources.requests.memory | string | `"150Mi"` |  |
| cdi.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| cdi.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| cdi.securityContext.runAsNonRoot | bool | `true` |  |
| cdi.securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| cdi.service.name | string | `"metrics"` |  |
| cdi.service.port | int | `8080` |  |
| cdi.service.protocol | string | `"TCP"` |  |
| cdi.service.type | string | `"ClusterIP"` |  |
| cdi.serviceAccount.annotations | object | `{}` |  |
| cdi.serviceAccount.create | bool | `true` |  |
| cdi.serviceAccount.name | string | `"kubevirt-cdi-service-account"` |  |
| cdi.tolerations[0].key | string | `"CriticalAddonsOnly"` |  |
| cdi.tolerations[0].operator | string | `"Exists"` |  |
| cdi.uploadProxy.port | int | `443` |  |
| cdi.uploadProxy.protocol | string | `"TCP"` |  |
| cdi.uploadProxy.targetPort | int | `8443` |  |
| cdi.uploadProxy.type | string | `"ClusterIP"` |  |
| manager.enabled | bool | `true` |  |
| manager.ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt-staging"` |  |
| manager.ingress.annotations."nginx.org/location-snippets" | string | `"proxy_set_header Upgrade $http_upgrade;\nproxy_set_header Connection $connection_upgrade;\n"` |  |
| manager.ingress.className | string | `"nginx"` |  |
| manager.ingress.enabled | bool | `false` |  |
| manager.ingress.hostname | string | `"kubevirt.example.com"` |  |
| manager.ingress.tls.enabled | bool | `false` |  |
| manager.ingress.tls.secretName | string | `"tls-kubevirt-manager"` |  |
| manager.prometheus.enabled | bool | `false` |  |
| manager.prometheus.port | int | `8080` |  |
| manager.prometheus.serviceName | string | `"mimir-query-frontend"` |  |
| manager.prometheus.serviceNamesapce | string | `"default"` |  |
| manager.replicaCount | int | `1` |  |
| manager.service.name | string | `"http"` |  |
| manager.service.port | int | `8080` |  |
| manager.service.protocol | string | `"TCP"` |  |
| manager.service.type | string | `"ClusterIP"` |  |
| operator.affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchExpressions":[{"key":"kubevirt.io","operator":"In","values":["virt-operator"]}]},"topologyKey":"kubernetes.io/hostname"},"weight":1}]}}` | by default forces replicas to different knodes |
| operator.featureGates[0] | string | `"ExpandDisks"` |  |
| operator.featureGates[10] | string | `"clientPassthrough"` |  |
| operator.featureGates[11] | string | `"Snapshot"` |  |
| operator.featureGates[12] | string | `"CPUNodeDiscovery"` |  |
| operator.featureGates[1] | string | `"CPUManager"` |  |
| operator.featureGates[2] | string | `"GPU"` |  |
| operator.featureGates[3] | string | `"HostDevices"` |  |
| operator.featureGates[4] | string | `"VMExport"` |  |
| operator.featureGates[5] | string | `"HotplugVolumes"` |  |
| operator.featureGates[6] | string | `"HostDisk"` |  |
| operator.featureGates[7] | string | `"Macvtap"` |  |
| operator.featureGates[8] | string | `"Passt"` |  |
| operator.featureGates[9] | string | `"HotplugNICs"` |  |
| operator.fullnameOverride | string | `""` |  |
| operator.image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| operator.image.repository | string | `"quay.io/kubevirt/virt-operator"` | container repository |
| operator.image.tag | string | `"v1.6.2"` | image tag, use this to set the version of kubevirt |
| operator.imagePullSecrets | list | `[]` |  |
| operator.mediatedDevicesTypes | list | `[]` |  |
| operator.monitorAccount | string | `""` |  |
| operator.monitorNamespace | string | `""` |  |
| operator.nameOverride | string | `""` |  |
| operator.nodeSelector | object | `{}` |  |
| operator.permittedHostDevices.mediatedDevices | list | `[]` |  |
| operator.permittedHostDevices.pciHostDevices | list | `[]` |  |
| operator.podAnnotations | object | `{}` |  |
| operator.podSecurityContext | object | `{}` |  |
| operator.priorityclass.create | bool | `true` | craete priorityclass by default |
| operator.priorityclass.value | int | `1000000000` | default priorityclass value |
| operator.replicaCount | int | `1` |  |
| operator.resources | object | `{}` |  |
| operator.securityContext.privileged | bool | `true` | sets the container to privileged |
| operator.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| operator.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| operator.serviceAccount.name | string | `"kubevirt-operator"` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| operator.tolerations | list | `[{"key":"CriticalAddonsOnly","operator":"Exists"}]` | toleration for CriticalAddonsOnly |
| operator.useEmulation | bool | `false` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
