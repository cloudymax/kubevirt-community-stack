# RKE2 test stack

I normally use k3s but im trying out RKE since its has etcd and works better with cilium.
This is my installation process.

## Architecture Choices

- [RKE2](https://docs.rke2.io/) is used as the kubernetes distro instead of [k3s](https://docs.k3s.io/) because it is a "full-fat" distro that is suitable for enterprise deployments. This choice was made because we wanted to test our K8s systems beyond the scale of just a "Lab" with a few nodes.

- We chose [Cilium](https://cilium.io/) as our CNI and are working on running it in [KubeProxyReplacement](https://docs.cilium.io/en/stable/network/kubernetes/kubeproxy-free/) mode. There are currently issues with this where DNS works properly in single-node setups but not in multi-node setups.

- [MetalLB](https://metallb.io/) remains our load-balancer of choice. This choice was made due to Cilium's LB implementation not working well for non-contiguous IP ranges (https://github.com/cilium/cilium/issues/28637) Using MetalLb also allows us to maintain continuity with Smol-K8s-Lab, and leaves room to impliment BGP routing at a later date.

- [Ingress-nginx](https://kubernetes.github.io/ingress-nginx/) remains the choice for ingress ad cilium's ingress did not work without manual intervention via changing annotations when using cert-manager and letsencrypt (https://github.com/cilium/cilium/issues/28852). Additionally, the built-in [ModSecurity WAF](https://kubernetes.github.io/ingress-nginx/user-guide/third-party-addons/modsecurity/), synergy with [Vouch-proxy](https://github.com/vouch/vouch-proxy) and [CertManager](https://cert-manager.io/) are very desireable features.

- [local-path-provisioner](https://github.com/rancher/local-path-provisioner) is provided as a quality-of-life feature. Operators may install additional storage systems at their own discretion.

## Networking

- [Multus CNI](https://github.com/k8snetworkplumbingwg/multus-cni) is enabled via RKE2 configuration and allows attaching additional network interfaces to pod using a [`NetworkAttachmentDefinition`](https://github.com/cloudymax/kubevirt-community-stack/tree/main/rke2/networkAttachmentDefinitions). Example [here](https://github.com/cloudymax/kubevirt-community-stack/blob/main/examples/pod-with-multus.yaml)

- Nodes are connected to a [Wireguard](https://www.wireguard.com/) VPN (we are using [Netmaker](https://www.netmaker.io/)).
  
- Each node has a virtual `wg0` ethernet device which Cilium may be configured to attach to.

- MetalLB can then advertise IP's on both the internal `192.168.X.X` and/or Wireguard `10.1.X.X` network ranges by configuring `L2Advertisement` resources as described [here](https://metallb.io/configuration/_advanced_l2_configuration/).

- Services of type `LoadBalancer` can be swapped between networks by setting the `metallb.universe.tf/address-pool` annotation.

- If the primary node needs to be brought down for maintenance, its Wireguard configuration may be moved to another node during that time to avoid long disruptions.

- Supporting real BGP is a future goal.

## Why we don't recommend Longhorn (yet)

While [Longhorn](https://longhorn.io/) is the easiest distributed block storage system to get started with and is also feature-rich - its v1 storage engine is too slow for our needs. The Longhorn volume v1 engine (with iscsi-tgt frontend) has a write bandwidth cap of 300-400 MiB/s. The bottleneck lives inside tgtd and there isn't a parameter or deployment method that we can adjust to improve it. See https://github.com/longhorn/longhorn/issues/3037 for full details.

The v2 engine seems to be much more performant, however is not stable on kernel versions below 6.7. Because we are on 6.2 with Debian12 we do not expect to revisit Longhorn until after the release of Debian13 later in 2025. 

## Install

If using multus with a bridged device, make sure forwarding is configured:

```bash
# Enable forwarding 
sudo iptables -F FORWARD && \
sudo iptables -I FORWARD -m physdev --physdev-is-bridged -j ACCEPT && \
sudo sysctl -w net.ipv4.ip_forward=1
```

1. Download RKE2 and kubelet config files

```bash
mkdir -p /etc/rancher/rke2
wget -O /etc/rancher/rke2/config.yaml \
	"https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/rke2/config.yaml"

mkdir -p /etc/kubernetes
wget -O /etc/kubernetes/kubelet.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/kubelet.yaml"
```

2. Download Add-on helm-charts and manifests

```bash
export DATA_DIR="/mnt/raid1/rancher/rke2"
mkdir -p ${DATA_DIR}

mkdir -p ${DATA_DIR}/server/manifests
wget -O ${DATA_DIR}/server/manifests/rke-cilium.yaml \
	"https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/rke-cilium.yaml"

wget -O ${DATA_DIR}/server/manifests/ingress-nginx.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/ingress-nginx.yaml"

wget -O ${DATA_DIR}/server/manifests/metallb.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/metlallb.yaml"

wget -O ${DATA_DIR}/server/manifests/ip-address-pool.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/ip-address-pool.yaml"

wget -O ${DATA_DIR}/server/manifests/cert-manager.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/cert-manager.yaml"

wget -O ${DATA_DIR}/server/manifests/hubble-ingress.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/hubble-ingress.yaml"

wget -O ${DATA_DIR}/server/manifests/nginx-hello.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/nginx-hello.yaml"

wget -O ${DATA_DIR}/server/manifests/local-path-provisioner.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/local-path-provisioner.yaml"

wget -O ${DATA_DIR}/server/manifests/multus-config.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/multus-config.yaml"
```

3. Download RKE2 and start cluster

```bash
export RKE2_VERSION="v1.31.8+rke2r1"
curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=${RKE2_VERSION} sh -
systemctl enable rke2-server.service
systemctl start rke2-server.service &
journalctl -u rke2-server -f
```

4. Copy kubeconfig and access cluster

```bash
sudo cp /etc/rancher/rke2/rke2.yaml /home/friend/.config/kube/config && \
chown friend:friend /home/friend/.config/kube/config && \
export KUBECONFIG=/home/friend/.config/kube/config
```

5. (GPUs) Install nvidia device exporter

```bash
kubecl apply -f https://raw.githubusercontent.com/NVIDIA/kubevirt-gpu-device-plugin/refs/heads/master/manifests/nvidia-kubevirt-gpu-device-plugin.yaml
```

## Adding more nodes

1. Get the node token from the control-plane

```bash
export DATA_DIR="/mnt/raid1/rancher/rke2"
sudo cat ${DATA_DIR}/server/node-token
```

2. Create the RKE2 config for the agent

```bash
export DATA_DIR="/mnt/raid1/rancher/rke2"
export NODE_IP="192.168.2.218"
export SERVER_IP="192.168.2.70"
export TOKEN=""
mkdir -p /etc/rancher/rke2/
mkdir -p ${DATA_DIR}

cat <<EOF > /etc/rancher/rke2/config.yaml
# /etc/rancher/k3s/config.yaml
# /etc/rancher/rke2/config.yaml
---
write-kubeconfig-mode: "0600"
server: https://${SERVER_IP}:9345
token: ${TOKEN}
node-ip: ${NODE_IP}
bind-address: ${NODE_IP}
node-external-ip: ${NODE_IP}
kubelet-arg:
- config=/etc/kubernetes/kubelet.yaml
data-dir: ${DATA_DIR}
EOF
```

3. Create the kubelet config

```bash
mkdir -p /etc/kubernetes
cat <<EOF > /etc/kubernetes/kubelet.yaml 
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cpuManagerReconcilePeriod: 0s
cpuManagerPolicy: static
cpuManagerPolicyOptions:
  full-pcpus-only: "true"
  distribute-cpus-across-numa: "true"
  align-by-socket: "true"
kubeReserved:
  cpu: "1"
  memory: "2Gi"
  ephemeral-storage: "1Gi"
systemReserved:
  cpu: "500m"
  memory: "1Gi"
  ephemeral-storage: "1Gi"
evictionHard:
  memory.available: "500Mi"
  nodefs.available: "10%"
featureGates:
  CPUManager: true
  CPUManagerPolicyOptions: true
  CPUManagerPolicyAlphaOptions: true
  CPUManagerPolicyBetaOptions: true
node-labels:
  node-role.kubernetes.io/worker: true
node-taints: 
  node-role.kubernetes.io/worker: "NoSchedule"
EOF
```

4. Download and run the installation script

```bash
export RKE2_VERSION="v1.31.8+rke2r1"
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" INSTALL_RKE2_VERSION=${RKE2_VERSION} sh -
systemctl enable rke2-agent.service
systemctl start rke2-agent.service &
journalctl -u rke2-agent -f
```

## Cleanup

- Delete RKE2 on workers and the control-plane

```bash
export DATA_DIR="/mnt/raid1/rancher/rke2"
sudo rke2-uninstall.sh
sudo rm -rf ${DATA_DIR}
```

- If only deleting a worker, remove its node secret from the control-plane

```
kubectl -n kube-system delete secrets bradley.node-password.rke2
```
