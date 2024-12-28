# kubevirt-stack

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.0](https://img.shields.io/badge/AppVersion-0.0.0-informational?style=flat-square)

Combined meta-chart for installing Kubevirt, its dependencies, and addons

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cloudymax | <emax@cloudydev.net> | <https://github.com/cloudymax/> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://cloudymax.github.io/kubevirt-community-stack | capi(cluster-api-operator) | 0.0.0 |
| https://cloudymax.github.io/kubevirt-community-stack | operator(kubevirt) | 0.2.8 |
| https://cloudymax.github.io/kubevirt-community-stack | cdi(kubevirt-cdi) | 0.2.1 |
| https://cloudymax.github.io/kubevirt-community-stack | manager(kubevirt-manager) | 0.2.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| capi.addon | string | `""` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key | string | `"kubernetes.io/arch"` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator | string | `"In"` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[0] | string | `"amd64"` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[1] | string | `"arm64"` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[2] | string | `"ppc64le"` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[1].key | string | `"kubernetes.io/os"` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[1].operator | string | `"In"` |  |
| capi.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[1].values[0] | string | `"linux"` |  |
| capi.args[0] | string | `"--leader-elect"` |  |
| capi.bootstrap | string | `"kubeadm:v1.7.2"` |  |
| capi.configSecret | object | `{}` |  |
| capi.containerSecurityContext | object | `{}` |  |
| capi.controlPlane | string | `"kubeadm:v1.7.2"` |  |
| capi.core | string | `"cluster-api:v1.7.2"` |  |
| capi.enabled | bool | `false` |  |
| capi.env.manager | list | `[]` |  |
| capi.image.manager.pullPolicy | string | `"IfNotPresent"` |  |
| capi.image.manager.repository | string | `"registry.k8s.io/capi-operator/cluster-api-operator"` |  |
| capi.image.manager.tag | string | `"v0.15.0"` |  |
| capi.imagePullSecrets | object | `{}` |  |
| capi.infrastructure | string | `"kubevirt:v0.1.8"` |  |
| capi.manager | object | `{}` |  |
| capi.replicaCount | int | `1` |  |
| capi.resources | object | `{}` |  |
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
| manager.prometheus.serviceName | string | `"thanos-app-query-frontend"` |  |
| manager.prometheus.serviceNamesapce | string | `"default"` |  |
| manager.replicaCount | int | `1` |  |
| manager.service.name | string | `"http"` |  |
| manager.service.port | int | `8080` |  |
| manager.service.protocol | string | `"TCP"` |  |
| manager.service.type | string | `"ClusterIP"` |  |
| operator.affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchExpressions":[{"key":"kubevirt.io","operator":"In","values":["virt-operator"]}]},"topologyKey":"kubernetes.io/hostname"},"weight":1}]}}` | by default forces replicas to different knodes |
| operator.featureGates | list | `[]` |  |
| operator.fullnameOverride | string | `""` |  |
| operator.image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| operator.image.repository | string | `"quay.io/kubevirt/virt-operator"` | container repository |
| operator.image.tag | string | `"v1.2.0"` | image tag, use this to set the version of kubevirt |
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
| operator.useEmulation | bool | `true` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
