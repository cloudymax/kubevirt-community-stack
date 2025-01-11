# Kubevirt Disks

Examples of how to create PVCs using the CLI instead of config files

## Debian12 Cloud Image

```bash
export VOLUME_NAME=debian12-pvc
export NAMESPACE="default"
export STORAGE_CLASS="local-path"
export ACCESS_MODE="ReadWriteOnce"
export IMAGE_URL="https://cloud.debian.org/images/cloud/bookworm/daily/latest/debian-12-generic-amd64-daily.qcow2"
export IMAGE_PATH=debian-12-generic-amd64-daily.qcow2
export VOLUME_TYPE=pvc
export SIZE=120Gi
export PROXY_ADDRESS=$(kubectl get svc cdi-uploadproxy -n cdi -o json | jq --raw-output '.spec.clusterIP')
# $(kubectl get svc cdi-uploadproxy -n cdi -o json | jq --raw-output

time wget -O $IMAGE_PATH $IMAGE_URL && \
time virtctl image-upload $VOLUME_TYPE $VOLUME_NAME \
    --size=$SIZE \
    --image-path=$IMAGE_PATH \
    --uploadproxy-url=https://$PROXY_ADDRESS:443 \
    --namespace=$NAMESPACE \
    --storage-class=$STORAGE_CLASS \
    --access-mode=$ACCESS_MODE \
    --insecure --force-bind
```

## Windows10 ISO

```bash
export VOLUME_NAME="windows10-iso-pvc"
export NAMESPACE="default"
export STORAGE_CLASS="local-path"
export ACCESS_MODE="ReadWriteOnce"
export IMAGE_URL="https://www.itechtics.com/?dl_id=173"
export IMAGE_PATH="Win10_22H2_EnglishInternational_x64.iso"
export VOLUME_TYPE="pvc"
export SIZE="8Gi"
export PROXY_ADDRESS=$(kubectl get svc cdi-uploadproxy -n cdi -o json | jq --raw-output '.spec.clusterIP')
# $(kubectl get svc cdi-uploadproxy -n cdi -o json | jq --raw-output

time wget -O $IMAGE_PATH $IMAGE_URL && \
time virtctl image-upload $VOLUME_TYPE $VOLUME_NAME \
    --size=$SIZE \
    --image-path=$IMAGE_PATH \
    --uploadproxy-url=https://$PROXY_ADDRESS:443 \
    --namespace=$NAMESPACE \
    --storage-class=$STORAGE_CLASS \
    --access-mode=$ACCESS_MODE \
    --insecure --force-bind
```

