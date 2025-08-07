# cloud-init

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart that generates cloud-init config files

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cloudymax |  |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argocdAppName | string | `"cloud-init-test"` | - ArgoCD App name for optional resource tracking |
| boot_cmd | list | `[]` | Run arbitrary commands early in the boot process See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#bootcmd |
| ca_certs | list | `[]` | Add CA certificates See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#ca-certificates |
| debug | bool | `false` | when enabled job sleeps to allow user to exec into the container |
| disable_root | bool | `false` | Disable root login over ssh |
| disk_setup[0] | object | `{"layout":true,"name":"/dev/vdb","overwrite":false,"table_type":"gpt"}` | The name of the device. |
| disk_setup[0].layout | bool | `true` | This is a list of values, with the percentage of disk that the partition will take. When layout is “true”, it instructs cloud-init to single-partition the entire device. When layout is “false” it means “don’t partition” or “ignore existing partitioning”. |
| disk_setup[0].overwrite | bool | `false` | “false” is the default which means that the device will be checked for a partition table and/or filesystem. “true” is cowboy mode, no checks. |
| disk_setup[0].table_type | string | `"gpt"` | Supported options ate `gpt` and `mbr` |
| envsubst | bool | `true` | Run envsubst against bootcmd and runcmd fields at the beginning of templating Not an official part of cloid-init |
| existingConfigMap | bool | `false` | Dont recreate script configmap. Set to true when keeping multiple cloud-init secrets in the same namespace |
| extraEnvVars[0].name | string | `"USERNAME"` |  |
| extraEnvVars[0].value | string | `"max"` |  |
| extraEnvVars[1].name | string | `"GITHUB_USER"` |  |
| extraEnvVars[1].value | string | `"cloudymax"` |  |
| extraEnvVars[2].name | string | `"REPO_OWNER"` |  |
| extraEnvVars[2].value | string | `"buildstar-online"` |  |
| extraEnvVars[3].name | string | `"REPO_NAME"` |  |
| extraEnvVars[3].value | string | `"nvidia-desktops"` |  |
| extraEnvVars[4].name | string | `"ACCESS_TOKEN"` |  |
| extraEnvVars[4].valueFrom.secretKeyRef.key | string | `"test.yaml"` |  |
| extraEnvVars[4].valueFrom.secretKeyRef.name | string | `"test"` |  |
| fs_setup[0] | object | `{"device":"/dev/vdb","filesystem":"ext4","label":"None","partition":"auto|any"}` | The device name. |
| fs_setup[0].filesystem | string | `"ext4"` | The filesystem type. Supports ext{2,3,4} and vfat |
| fs_setup[0].label | string | `"None"` | The filesystem label to be used. If set to “None”, no label is used. |
| fs_setup[0].partition | string | `"auto|any"` | Options are `auto|any`, `auto`, or `any` |
| hostname | string | `"random"` | virtual-machine hostname |
| image | string | `"deserializeme/kv-cloud-init:v0.0.1"` | image version |
| mounts | list | `[]` | Set up mount points. mounts contains a list of lists. The inner list contains entries for an /etc/fstab line |
| namespace | string | `"kubevirt"` | namespace in which to create resources |
| network | object | `{"config":"disabled"}` | networking options |
| network.config | string | `"disabled"` | disable cloud-init’s network configuration capability and rely on other methods such as embedded configuration or other customisations. |
| package_reboot_if_required | bool | `false` | Update, upgrade, and install packages See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#package-update-upgrade-install |
| package_update | bool | `true` |  |
| package_upgrade | bool | `false` |  |
| packages[0] | string | `"ssh-import-id"` |  |
| packages[10] | string | `"open-iscsi"` |  |
| packages[11] | string | `"nfs-common"` |  |
| packages[12] | string | `"bc"` |  |
| packages[13] | string | `"zip"` |  |
| packages[14] | string | `"pkg-config"` |  |
| packages[15] | string | `"pipx"` |  |
| packages[16] | string | `"jq"` |  |
| packages[1] | string | `"curl"` |  |
| packages[2] | string | `"tmux"` |  |
| packages[3] | string | `"apt-transport-https"` |  |
| packages[4] | string | `"ca-certificates"` |  |
| packages[5] | string | `"software-properties-common"` |  |
| packages[6] | string | `"git-extras"` |  |
| packages[7] | string | `"rsyslog"` |  |
| packages[8] | string | `"vim"` |  |
| packages[9] | string | `"gpg"` |  |
| runcmd | list | `["mkdir -p /home/${USERNAME}/shared","chown ${USERNAME}:${USERNAME} /home/${USERNAME}/shared","sudo -u ${USERNAME} -i ssh-import-id-gh ${GITHUB_USER}","curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg","echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null","sudo apt-get update","sudo apt-get install -y docker-ce","wget https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh","chmod +x /install.sh","chmod 777 /install.sh","sudo -u ${USERNAME} NONINTERACTIVE=1 /bin/bash /install.sh","sudo -u ${USERNAME} /home/linuxbrew/.linuxbrew/bin/brew shellenv >> /home/${USERNAME}/.profile","sudo -u ${USERNAME} /home/linuxbrew/.linuxbrew/opt/python@3.11/libexec/bin >> /home/${USERNAME}/.profile","sudo -u ${USERNAME} /home/linuxbrew/.linuxbrew/bin/brew install python@3.11","sudo chown -R ${USERNAME}:${USERNAME} /home/linuxbrew","sudo chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}","wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq","chmod +x /usr/bin/yq"]` | Run arbitrary commands See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#runcmd |
| salt | string | `"saltsaltlettuce"` | salt used for password generation |
| secret_name | string | `"max-scrapmetal-user-data"` | name of secret in which to save the user-data file |
| serviceAccount | object | `{"create":true,"existingServiceAccountName":"cloud-init-sa","name":"cloud-init-sa"}` | Choose weather to create a service-account or not. Once a SA has been created you should set this to false on subsequent runs. |
| swap | object | `{"enabled":false,"filename":"/swapfile","maxsize":"1G","size":"1G"}` | creates a swap file using human-readable values. |
| users | list | `[{"groups":"users, admin, docker, sudo, kvm","lock_passwd":false,"name":"pool","password":{"random":true},"shell":"/bin/bash","ssh_authorized_keys":[],"ssh_import_id":[],"sudo":"ALL=(ALL) NOPASSWD:ALL"}]` | user configuration options See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#users-and-groups do NOT use 'admin' as username - it conflicts with multiele cloud-images |
| users[0].password | object | `{"random":true}` | set user password from existing secret or generate random |
| users[0].ssh_authorized_keys | list | `[]` | provider user ssh pub key as plaintext |
| users[0].ssh_import_id | list | `[]` | import user ssh public keys from github, gitlab, or launchpad See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#ssh |
| wireguard | list | `[]` | add wireguard configuration from existing secret or as plain-text See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#wireguard |
| write_files | list | `[{"path":"/home/${USERNAME}/runner.sh","permissions":"0644","url":"https://raw.githubusercontent.com/small-hack/smol-metal/refs/heads/main/gha-runner.sh"},{"path":"/etc/apt-sources.list","permissions":"0644","url":"https://raw.githubusercontent.com/small-hack/smol-metal/refs/heads/main/etc-apt-sources.list"},{"path":"/etc/default/laocalw","permissions":"0644","url":"https://raw.githubusercontent.com/small-hack/smol-metal/refs/heads/main/etc-default-locale"},{"path":"/etc/default/keyboard","permissions":"0644","url":"https://raw.githubusercontent.com/small-hack/smol-metal/refs/heads/main/etc-default-keyboard"},{"path":"/etc/ssh/sshd_config","permissions":"0644","url":"https://raw.githubusercontent.com/small-hack/smol-metal/refs/heads/main/sshd_config"}]` | Write arbitrary files to disk. Files my be provided as plain-text or downloaded from a url See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#write-files |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
