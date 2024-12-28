# Install

1. Download RKE2 and kubelet config files

```bash
mkdir -p /etc/rancher/rke2
wget -O /etc/rancher/rke2/config.yaml \
	"https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/rke2/config.yaml"

mkdir -p /etc/kubernetes
wget -O /etc/kubernetes/kubeletconfig.yml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/kubeletconfig.yml"
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

wget -O /etc/kubernetes/local-path-provisioner.yaml \
    "https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/local-path-provisioner.yaml"
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
