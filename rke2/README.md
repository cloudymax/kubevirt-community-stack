# RKE2 test stack

I normally use k3s but im trying out RKE since its has etcd and works better with cilium.
This is my installation process.

## Choices

- RKE2 is used as the kubernetes distro instead of k3s because it is a "full-fat" distro that is suitable for enterprise deployments. This choice was made because I wanted to test our K8s systems beyond the scale of just a "Lab" with a few nodes.

- MetalLB remains the load-balancer of choice but is now paired with Cilium as the CNI running as a KubeProxy replacement. This choice was made due to Cilium's LB implementation not working well for non-contiguous IP ranges and to maintain continuity with Smol-K8s-Lab.

- Ingress-nginx remains the choice for ingress ad cilium's ingress did not work without manual intervention and the use of the `acme.cert-manager.io/http01-edit-in-place` annotation when using cert-manager and letsencrypt. Plus, having access to the build-in ModSecurity WAF on Nginx + its synergy with Vouch-proxy is a highly desired.

- local-path-provisioner is provided for simplicity and quality of life but another file-system such as Longhorn is advised to be installed at the operators discretion.

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

wget -O /var/lib/rancher/rke2/server/manifests/kubevirt-stack.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/kubevirt-stack.yaml"
```

3. Download RKE2 and start cluster

```bash
curl -sfL https://get.rke2.io | sh -
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

