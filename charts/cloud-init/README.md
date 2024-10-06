# cloud-init

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart that generates cloud-init config files

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| boot_cmd | list | `["mkdir -p /home/friend/.config/smol-k8s-lab"]` | Run arbitrary commands early in the boot process See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#bootcmd |
| ca_certs | list | `[]` | Add CA certificates See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#ca-certificates |
| disable_root | bool | `false` |  |
| envsubst | list | `[{"value":"max","var":"USERNAME"}]` | Run envsubst against the cloud-init file at the beginning of templating Not an official part of cloid-init |
| hostname | string | `"scrapmetal"` | virtual-machine hostname |
| image | string | `"deserializeme/kv-cloud-init:v0.0.1"` | image version |
| namespace | string | `"kubevirt"` | namespace in which to create resources |
| network | object | `{"config":"disabled"}` | networking options |
| network.config | string | `"disabled"` | disable cloud-init’s network configuration capability and rely on other methods such as embedded configuration or other customisations. |
| package_reboot_if_required | bool | `true` | Update, upgrade, and install packages See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#package-update-upgrade-install |
| package_update | bool | `true` |  |
| package_upgrade | bool | `true` |  |
| packages[0] | string | `"wireguard"` |  |
| packages[10] | string | `"htop"` |  |
| packages[11] | string | `"iotop"` |  |
| packages[12] | string | `"git-extras"` |  |
| packages[13] | string | `"rsyslog"` |  |
| packages[14] | string | `"fail2ban"` |  |
| packages[15] | string | `"gpg"` |  |
| packages[16] | string | `"open-iscsi"` |  |
| packages[17] | string | `"nfs-common"` |  |
| packages[18] | string | `"ncdu"` |  |
| packages[19] | string | `"nvtop"` |  |
| packages[1] | string | `"openresolv"` |  |
| packages[20] | string | `"linux-headers-generic"` |  |
| packages[21] | string | `"gcc"` |  |
| packages[22] | string | `"kmod"` |  |
| packages[23] | string | `"make"` |  |
| packages[24] | string | `"pkg-config"` |  |
| packages[25] | string | `"libvulkan1"` |  |
| packages[2] | string | `"ssh-import-id"` |  |
| packages[3] | string | `"sudo"` |  |
| packages[4] | string | `"curl"` |  |
| packages[5] | string | `"tmux"` |  |
| packages[6] | string | `"netplan.io"` |  |
| packages[7] | string | `"apt-transport-https"` |  |
| packages[8] | string | `"ca-certificates"` |  |
| packages[9] | string | `"software-properties-common"` |  |
| runcmd | list | `["wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\\","chmod +x /usr/bin/make","sudo chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}","curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg","echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null","sudo apt-get update","sudo apt-get install -y docker-ce"]` | Run arbitrary commands See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#runcmd |
| secret_name | string | `"max-scrapmetal-user-data"` | name of secret in which to save the user-data file |
| users | list | `[{"groups":"users, admin, docker, sudo, kvm","lock_passwd":false,"name":"admin","password":{"existingSecret":{"key":"password","name":"admin-password"},"random":"false"},"shell":"/bin/bash","ssh_authorized_keys":["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUTNigmB9CbSE3WaTeqsEgJzkdftozwcpduuv1EXWFNFcdohARabubYw1Kz14sXg5wSz+MXMgo/XMBu+EtuF8zlEpYp9tuY5M9+X6i/vLilih0eVMFRZAx9Exj3Rwwn1Sjqk4iUxW9VaH1SS7MpWsO+qN4aGeXtkkSvkts2dLAGVIf2Hto/09+f8Pe8dKqnsNYk0rrKjBP2ZPPLcA1tc3bcYzK3/6OwOZaPOgD+bQiFnr2fSj+D8AtEnM2gpetmPhL2I+WNQnm90JH16+S899ZWvSM3cKwN9zkGq4SgFWwLfBP5z6yQRIVcxL9lMF3A0Dqc/qkzP30hUhunXT7oGGzo5U5yqrgjv/0RsAwwpCf7mCWreV/SrFpoPcoiZCiHd2xoiVhb4lArNtxqXlnCFHh+ZvtI0otAkf3hE7OzRxEZw04TXIePdiMi1LOXgU1++r7Qs0kEhP0bVCbnA4Rpev/11uYm9GeNl9WAwAlc9/tKu/6zWTO3/9jBNbADqm6qG8= friend"],"ssh_import_id":["gh:cloudymax"],"sudo":"ALL=(ALL) NOPASSWD:ALL"}]` | user configuration options See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#users-and-groups |
| users[0].password | object | `{"existingSecret":{"key":"password","name":"admin-password"},"random":"false"}` | set user password from existing secret or generate random |
| users[0].ssh_authorized_keys | list | `["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUTNigmB9CbSE3WaTeqsEgJzkdftozwcpduuv1EXWFNFcdohARabubYw1Kz14sXg5wSz+MXMgo/XMBu+EtuF8zlEpYp9tuY5M9+X6i/vLilih0eVMFRZAx9Exj3Rwwn1Sjqk4iUxW9VaH1SS7MpWsO+qN4aGeXtkkSvkts2dLAGVIf2Hto/09+f8Pe8dKqnsNYk0rrKjBP2ZPPLcA1tc3bcYzK3/6OwOZaPOgD+bQiFnr2fSj+D8AtEnM2gpetmPhL2I+WNQnm90JH16+S899ZWvSM3cKwN9zkGq4SgFWwLfBP5z6yQRIVcxL9lMF3A0Dqc/qkzP30hUhunXT7oGGzo5U5yqrgjv/0RsAwwpCf7mCWreV/SrFpoPcoiZCiHd2xoiVhb4lArNtxqXlnCFHh+ZvtI0otAkf3hE7OzRxEZw04TXIePdiMi1LOXgU1++r7Qs0kEhP0bVCbnA4Rpev/11uYm9GeNl9WAwAlc9/tKu/6zWTO3/9jBNbADqm6qG8= friend"]` | provider user ssh pub key as plaintext |
| users[0].ssh_import_id | list | `["gh:cloudymax"]` | import user ssh public keys from github, gitlab, or launchpad See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#ssh |
| wireguard | object | `{"interfaces":[{"config_path":"/etc/wireguard/wg0.conf","existingSecret":{"key":"wg0.conf","name":"wg0-credentials"},"name":"wg0"}]}` | add wireguard configuration from existing secret or as plain-text See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#wireguard |
| write_files | list | `[{"path":"/etc/ssh/ssh_config","permissions":"0644","url":"https://raw.githubusercontent.com/small-hack/smol-metal/refs/heads/main/sshd_config"},{"path":"/etc/apt/sources.list","permissions":"0644","url":"https://raw.githubusercontent.com/small-hack/smol-metal/refs/heads/main/etc-apt-sources.list"},{"path":"/etc/default/keyboard","permissions":"0644","url":"https://raw.githubusercontent.com/small-hack/smol-metal/refs/heads/main/etc-default-keyboard"},{"path":"/etc/gdm3/daemon.conf","permissions":"0644","url":"https://raw.githubusercontent.com/small-hack/smol-metal/refs/heads/main/etc-gdm3-daemon.conf"},{"path":"/etc/default/locale","permissions":"0644","url":"https://raw.githubusercontent.com/small-hack/smol-metal/refs/heads/main/etc-default-locale"},{"path":"/home/${USERNAME}/.config/systemd/user/sunshine.service","permissions":"0644","url":"https://raw.githubusercontent.com/small-hack/smol-metal/refs/heads/main/home-USERNAME-.config-systemd-user-sunshine.service"},{"content":"foo: bar","path":"/tmp/test.yaml","permissions":"0644"}]` | Write arbitrary files to disk. Files my be provided as plain-text or downloaded from a url See https://cloudinit.readthedocs.io/en/latest/reference/modules.html#write-files |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
