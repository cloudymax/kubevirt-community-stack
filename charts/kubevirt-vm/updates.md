# Updating this chart

The current process is the following steps + manual checking of diffs

```bash
pipx install semver

pysemver bump minor 1.2.3

export APPVERSION="v1.6.2"
export REPO=/Users/max/repos/kubevirt-community-stack/charts/kubevirt
export CHART_VERSION=$(cat $REPO/Chart.yaml |yq '.version')
export NEW_CHART_VERSION=$(pysemver bump minor $CURRENT_VERSION)

wget https://github.com/kubevirt/kubevirt/releases/download/$VERSION/kubevirt-operator.yaml
yq -s '$index + "-" + .kind + ".yaml"' kubevirt-operator.yaml
rm kubevirt-operator.yaml

mv *CustomResourceDefinition.yaml $REPO/crds/CustomResourceDefinition.yaml

mv $(ls *ClusterRole.yaml |xargs |awk '{print $1}') $REPO/templates/ClusterRole0.yaml

mv $(ls *ClusterRole.yaml |xargs |awk '{print $1}') $REPO/templates/ClusterRole1.yaml

mv *PriorityClass.yaml  $REPO/templates/PriorityClass.yaml

mv *ServiceAccount.yaml  $REPO/templates/ServiceAccount.yaml

mv *Role.yaml  $REPO/templates/Role.yaml

mv *RoleBinding.yaml  $REPO/templates/RoleBinding.yaml

mv *ClusterRoleBinding.yaml  $REPO/templates/ClusterRoleBinding.yaml

mv *Deployment.yaml  $REPO/templates/Deployment.yaml

rm *Namespace.yaml

yq -i '.appVersion = env(APPVERSION)' $REPO/Chart.yaml
yq -i '.version = env(NEW_CHART_VERSION)' $REPO/Chart.yaml

helm-docs 
```
