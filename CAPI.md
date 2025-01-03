# Creating a cluster using CAPI

1. Set versions:

    ```bash
    export CAPK_GUEST_K8S_VERSION="v1.30.1"
    export CRI_PATH="/var/run/containerd/containerd.sock"
    export NODE_VM_IMAGE_TEMPLATE="quay.io/capk/ubuntu-2204-container-disk:${CAPK_GUEST_K8S_VERSION}"
    ```

2. Generate base config:

    ```bash
    clusterctl generate cluster capi \
       --infrastructure="kubevirt:v0.1.9" \
       --flavor lb-kccm \
       --kubernetes-version ${CAPK_GUEST_K8S_VERSION} \
       --control-plane-machine-count=1 \
       --worker-machine-count=2 > capi-quickstart.yaml
    ```

3. Steps to avoid errors:

    - Set a cpu model in each KubevirtMachineTemplate. This prevents an issue where QEMU cannot request the desired features from the host CPU.

    ```yaml
    apiVersion: infrastructure.cluster.x-k8s.io/v1alpha1
    kind: KubevirtMachineTemplate
    metadata:
      name: capi-control-plane
      namespace: kubevirt
    spec:
      template:
        spec:
          virtualMachineBootstrapCheck:
            checkStrategy: ssh
          virtualMachineTemplate:
            metadata:
              namespace: kubevirt
            spec:
              runStrategy: Always
              template:
                spec:
                  domain:
                    cpu:
                      model: EPYC-Rome
                      cores: 2
                    devices:
                      disks:
                        - disk:
                            bus: virtio
                          name: containervolume
                      networkInterfaceMultiqueue: true
                    memory:
                      guest: 4Gi
                  evictionStrategy: External
                  volumes:
                    - containerDisk:
                        image: quay.io/capk/ubuntu-2204-container-disk:v1.30.1
                      name: containervolume
    ```

    - Remove the node selector from the kubevirt-cloud-controller-manager Deployment. This prevents a failure to deploy the manager pod.

    - Un-quote the cluster-name string from the args section of the kubevirt-cloud-controller-manager Deployment. This prevents an issue where the quotes are perceived as part of the label value and causes an invalid name error to prevent LB creation.
    
    - Add labels to nodes:
	
	```yaml
	labels:
 	  cluster.x-k8s.io/cluster-name: <tenant-cluster-name>
	  cluster.x-k8s.io/role: worker
 	```

4. Apply the manifests to create the tenant cluster:

    ```bash
    kubectl apply -f capi-quickstart.yaml
    ```

5. Get the kubeconfig from the tenant cluster

    ```bash
    clusterctl get kubeconfig capi > capi-quickstart.kubeconfig
    ```

6. Install the calico CNI:

    ```bash
    curl https://raw.githubusercontent.com/projectcalico/calico/v3.24.4/manifests/calico.yaml -o calico-workload.yaml
    ```

    ```bash
    sed -i -E 's|^( +)# (- name: CALICO_IPV4POOL_CIDR)$|\1\2|g;'\
    's|^( +)# (  value: )"192.168.0.0/16"|\1\2"10.243.0.0/16"|g;'\
    '/- name: CLUSTER_TYPE/{ n; s/( +value: ").+/\1k8s"/g };'\
    '/- name: CALICO_IPV4POOL_IPIP/{ n; s/value: "Always"/value: "Never"/ };'\
    '/- name: CALICO_IPV4POOL_VXLAN/{ n; s/value: "Never"/value: "Always"/};'\
    '/# Set Felix endpoint to host default action to ACCEPT./a\            - name: FELIX_VXLANPORT\n              value: "6789"' \
    calico-workload.yaml
    ```

    ```bash
    kubectl --kubeconfig=./capi-quickstart.kubeconfig create -f calico-workload.yaml
    ```

7. Install an app that uses a LoadBalancer into the tenant cluster:

    ```bash
    ka https://raw.githubusercontent.com/cloudymax/kubevirt-community-stack/refs/heads/main/rke2/server/manifests/ingress-nginx.yaml \
	--kubeconfig=./capi-quickstart.kubeconfig
    ```
