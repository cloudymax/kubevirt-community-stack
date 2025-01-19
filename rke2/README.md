# RKE2 test stack

I normally use k3s but im trying out RKE since its has etcd and works better with cilium.
This is my installation process.

## Architecture Choices

- [RKE2](https://docs.rke2.io/) is used as the kubernetes distro instead of [k3s](https://docs.k3s.io/) because it is a "full-fat" distro that is suitable for enterprise deployments. This choice was made because we wanted to test our K8s systems beyond the scale of just a "Lab" with a few nodes.

- We chose [Cilium](https://cilium.io/) as our CNI and run it in [KubeProxyReplacement](https://docs.cilium.io/en/stable/network/kubernetes/kubeproxy-free/) mode.

- [MetalLB](https://metallb.io/) remains our load-balancer of choice. This choice was made due to Cilium's LB implementation not working well for non-contiguous IP ranges (https://github.com/cilium/cilium/issues/28637) Using MetalLb also allows us to maintain continuity with Smol-K8s-Lab, and leaves room to impliment BGP routing at a later date.

- [Ingress-nginx](https://kubernetes.github.io/ingress-nginx/) remains the choice for ingress ad cilium's ingress did not work without manual intervention via changing annotations when using cert-manager and letsencrypt (https://github.com/cilium/cilium/issues/28852). Additionally, the built-in [ModSecurity WAF](https://kubernetes.github.io/ingress-nginx/user-guide/third-party-addons/modsecurity/), synergy with [Vouch-proxy](https://github.com/vouch/vouch-proxy) and [CertManager](https://cert-manager.io/) are very desireable features.

- [local-path-provisioner](https://github.com/rancher/local-path-provisioner) is provided as a quality-of-life feature. Operators may install additional storage systems at their own discretion.

## Networking

- Nodes are connected to a [Wireguard](https://www.wireguard.com/) VPN (we are using [Netmaker](https://www.netmaker.io/)).
  
- Each node has a virtual `wg0` ethernet device which Cilium is configured to attach to.

- MetalLB can then advertise IP's on both the internal `192.168.X.X` and/or Wireguard `10.1.X.X` network ranges by configuring `L2Advertisement` resources as described [here](https://metallb.io/configuration/_advanced_l2_configuration/).

- Services of type `LoadBalancer` can be swapped between networks by setting the `metallb.universe.tf/address-pool` annotation.

- If the primary node needs to be brought down for maintenance, its Wireguard configuration may be moved to another node during that time to avoid long disruptions.

- Supporting real BGP is a future goal.


## Why we don't recommend Longhorn (yet)

While [Longhorn](https://longhorn.io/) is the easiest distributed block storage system to get started with and is also feature-rich - its v1 storage engine is too slow for our needs. The Longhorn volume v1 engine (with iscsi-tgt frontend) has a write bandwidth cap of 300-400 MiB/s. The bottleneck lives inside tgtd and there isn't a parameter or deployment method that we can adjust to improve it. See https://github.com/longhorn/longhorn/issues/3037 for full details.

The v2 engine seems to be much more performant, however is not stable on kernel versions below 6.7. Because we are on 6.2 with Debian12 we do not expect to revisit Longhorn until after the release of Debian13 later in 2025. 

## Install

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
mkdir -p /var/lib/rancher/rke2/server/manifests
wget -O /var/lib/rancher/rke2/server/manifests/rke-cilium.yaml \
	"https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/rke-cilium.yaml"

wget -O /var/lib/rancher/rke2/server/manifests/ingress-nginx.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/ingress-nginx.yaml"

wget -O /var/lib/rancher/rke2/server/manifests/metallb.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/metlallb.yaml"

wget -O /var/lib/rancher/rke2/server/manifests/ip-address-pool.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/ip-address-pool.yaml"

wget -O /var/lib/rancher/rke2/server/manifests/cert-manager.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/cert-manager.yaml"

wget -O /var/lib/rancher/rke2/server/manifests/hubble-ingress.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/hubble-ingress.yaml"

wget -O /var/lib/rancher/rke2/server/manifests/nginx-hello.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/nginx-hello.yaml"

wget -O /var/lib/rancher/rke2/server/manifests/local-path-provisioner.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/local-path-provisioner.yaml"
```

3. Download RKE2 and start cluster

```bash
curl -sfL https://get.rke2.io | sh -

export INSTALL_RKE2_CHANNEL=v1.30.8+rke2r1
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

