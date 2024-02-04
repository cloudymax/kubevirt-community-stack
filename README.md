
<h1 align=center>
Kubevirt Charts (Work in Progress)
</h1>
<p align="center">
  <img width="64" src="https://avatars.githubusercontent.com/u/18700703?s=200&v=4">
</p>
<p align=center>
  A Collection of Helm3 charts for use with Kubevirt
  <br>
  <a href="https://cloudymax.github.io/kubevirt-community-stack/">cloudymax.github.io/kubevirt-community-stack</a>
</p>
<br>

<h2>
  Charts
</h2>

<p>

- <a href="https://github.com/cloudymax/kubevirt-charts/blob/main/charts/kubevirt-crds">kubevirt</a>: Installs the CRDS needed for the Operator and CDI.


- <a href="https://github.com/cloudymax/kubevirt-charts/blob/main/charts/kubevirt">kubevirt</a>: Installs the Kubevirt Operator.

    ```bash
    helm repo add kubevirt https://cloudymax.github.io/kubevirt-charts
    helm install kubevirt kubevirt/kubevirt
    ```

- <a href="https://github.com/cloudymax/kubevirt-charts/blob/main/charts/kubevirt-cdi">kubevirt-cdi</a>: Install the Containerized Data Importer.

    ```bash
    helm repo add kubevirt https://cloudymax.github.io/kubevirt-charts
    helm install kubevirt-cdi kubevirt/kubevirt-cdi \
      --namespace cdi \
      --create-namespace
    ```
    
- <a href="https://github.com/cloudymax/kubevirt-charts/blob/main/charts/cloud-init">cloud-init</a>: Generate a standalone cloud-init configuration file for use with other tools.

    ```bash
    git clone https://github.com/cloudymax/kubevirt-charts.git
    cd kubevirt-charts/charts/cloud-init
    helm template . -f values.yaml > cloud-init.yaml
    ```
  
- <a href="https://github.com/cloudymax/kubevirt-charts/blob/main/charts/kubevirt-vm">kubevirt-vm</a>: Create virtual-machines and vm-pools with Kubevirt via helm

    ```bash
    # Customize your own values.yaml before deploying
    helm repo add kubevirt https://cloudymax.github.io/kubevirt-charts
    helm install kubevirt-cdi kubevirt/kubevirt-vm \
      --file values.yaml  \
      --create-namespace
    ```

- <a href="https://github.com/cloudymax/kubevirt-charts/blob/main/charts/kubevirt-manager">kubevirt-manager</a>: Deploy the Kubevirt-Manager UI
    
    ```bash
    # Customize your own values.yaml before deploying
    helm repo add kubevirt https://cloudymax.github.io/kubevirt-charts
    helm install kubevirt-cdi kubevirt/kubevirt-manager \
      --file values.yaml  \
      --create-namespace
    ```
