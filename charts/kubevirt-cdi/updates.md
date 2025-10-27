# Update process

Steps below plus manual inspection

```bash
pipx install semver

export APPVERSION="v1.63.1"
export REPO=/Users/max/repos/kubevirt-community-stack/charts/kubevirt-cdi
export CHART_VERSION=$(cat $REPO/Chart.yaml |yq '.version')
export NEW_CHART_VERSION=$(pysemver bump minor $CHART_VERSION)

wget https://github.com/kubevirt/containerized-data-importer/releases/download/$APPVERSION/cdi-operator.yaml
yq -s '$index + "-" + .kind + ".yaml"' cdi-operator.yaml
rm cdi-operator.yaml
rm *-Namespace.yaml
rm *-Deployment.yaml

mv *-CustomResourceDefinition.yaml $REPO/crds/CustomResourceDefinition.yaml

mv *-ClusterRole.yaml $REPO/templates/ClusterRole.yaml

mv *-ServiceAccount.yaml $REPO/templates/ServiceAccount.yaml

mv *-Role.yaml $REPO/templates/Role.yaml

mv *-ClusterRoleBinding.yaml $REPO/templates/ClusterRoleBinding.yaml

mv *-RoleBinding.yaml $REPO/templates/RoleBinding.yaml

yq -i '.appVersion = env(APPVERSION)' $REPO/Chart.yaml
yq -i '.version = env(NEW_CHART_VERSION)' $REPO/Chart.yaml

helm-docs 
``
