# Base Windows Image

Creating windows virtual machines is not as straight-forward as with Linux. By default windows lacks the `virtio` drivers to properly utilize high-perforamnce storage and networking capabilities of QEMU. Dues to this we need to construct the Windows VM in stages.

In this first stage we will:

1. Download an installer ISO to a PVC using the CDI
2. Create a blank disk to install the OS into
3. Download the `virtio` drivers as a container image so we can install them

## Downloading an Installer Image

Since Windows is proprietary software, downloading an ISO is not as straight-forward as with Linux.

- Server and Enterprise

  Microsoft makes evaluation copies of it's server and enterprise images available through their
  Evaluation Center. You will need to enter your contact details to obtain the image. These
  evaluation images are multi-edition and therefore do not easily work for automated installation.

  - [Windows Server 2022](https://info.microsoft.com/ww-landing-windows-server-2022.html)

- Home and Pro

  You can also obtain an image for Windows 10 from Microsoft. This is another multi-edition image
  that cannot be easily automated due to the need to manually select the version to install during
  the setup process.

  - [Windows 10 Multi-edition](https://www.microsoft.com/nl-nl/software-download/windows10ISO)

- Alternative Sources for single-edition images

  For those who need a single-edition ISO which can be fully automated, it is easier to use 3rd
  party services such as [https://uupdump.net/](https://uupdump.net/) to obtain the ISO image. There
  is a decent guide [HERE](https://www.elevenforum.com/t/uup-dump-download-windows-insider-iso.344/)
  on how to use the site.

- Licenses

  Be aware that all of the images above are unlicensed and it is up to you to obtain a valid
  activation key for your installation. See
  [this post](https://www.reddit.com/r/cheapwindowskeys/comments/wjvsae/cheap_windows_keys/) on
  Reddit's /r/cheapwindowskeys for more information about how to acquire a license.

Once you have your ISO you can upload it to a PVC using the CDI as described in the [Work with Disk Images via the CDI](https://github.com/cloudymax/kubevirt-community-stack/blob/main/examples/disks/upload-local-image.md) doc. You could also download an existing image from the web:

    ```yaml
    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: "windows-installer"
      namespace: windows10
      labels:
        app: containerized-data-importer
      annotations:
        cdi.kubevirt.io/storage.bind.immediate.requested: "true"
        cdi.kubevirt.io/storage.import.endpoint: "https://f004.backblazeb2.com/file/buildstar-public-share/Win10_22H2_EnglishInternational_x64v1.iso"
    spec:
      storageClassName: fast-raid
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 8Gi
    ```

## Creating the vm

For this step, I assume that:
- your installation ISO PVC is named 'windows-installer' in the namespace `windows10`
- you are using the `local-path` storage class

```bash
cat <<EOF > windows-install.yaml
virtualMachine:
  name: windows10-base

  namespace: windows10

  runStrategy: "Once"

  features:
    kvm:
      enabled: true
      hidden: false
    hyperv: true
    acpiEnabled: true

  clock:
    enabled: true
    timezone: utc
    hpet:
      enabled: true
      present: false
    pit:
      enabled: true
      tickPolicy: delay
    rtc:
      enabled: true
      tickPolicy: catchup
    kvm: true
    hyperv: true

  machine:
    vCores: 4
    memory:
      base: 8Gi

disks:
  - name: installer-iso
    type: cdrom
    bus: sata
    bootorder: 1
    readonly: true
    pvsize: 8Gi
    pvstorageClassName: local-path
    pvaccessMode: ReadWriteOnce
    source: pvc
    pvcnamespace: windows10
    pvcname: windows-installer

  - name: windows-system
    type: disk
    bus: virtio
    bootorder: 2
    readonly: false
    pvsize: 24Gi
    pvstorageClassName: local-path
    pvaccessMode: ReadWriteOnce

  - name: windows-guest-tools
    type: cdrom
    bus: sata
    bootorder: 3
    readonly: true
    image: "quay.io/kubevirt/virtio-container-disk:v1.6.2"

service: []

ingress:
  enabled: false
  annotations: {}
  tls:
    enabled: false
EOF
```

Deploy the VM
```bash
helm install windows10-base kubevirt/kubevirt-vm \
    -n windows10 \
    -f windows-install.yaml
```

Connect to the VM over VNC - you will need a VNC viewer installed on your machine or need to be using the Kubevirt-Manager WebUI.

https://kubevirt.io/user-guide/user_workloads/accessing_virtual_machines/

```console
virtctl vnc --help
Open a vnc connection to a virtual machine instance.

Usage:
  virtctl vnc (VMI) [flags]
  virtctl vnc [command]

Examples:
  # Connect to 'testvmi' via remote-viewer:
   virtctl vnc testvmi

Available Commands:
  screenshot  Create a VNC screenshot of a virtual machine instance.

Flags:
      --address string    --address=127.0.0.1: Setting this will change the listening address of the VNC server. Example: --address=0.0.0.0 will make the server listen on all interfaces. (default "127.0.0.1")
  -h, --help              help for vnc
      --port int          --port=0: Assigning a port value to this will try to run the proxy on the given port if the port is accessible; If unassigned, the proxy will run on a random port
      --proxy-only        --proxy-only=false: Setting this true will run only the virtctl vnc proxy and show the port where VNC viewers can connect
      --vnc-path string   --vnc-path=/path/to/vnc: Specify the path to the VNC viewer executable. Must provide --vnc-type
      --vnc-type string   --vnc-type=tiger: Specify the type of VNC viewer to use (tiger, chicken, real, remote-viewer). Must provide --vnc-path

Use "virtctl options" for a list of global command-line options (applies to all commands).
```

```bash
virtctl vnc windows10-base
```

Once you have connected to the VM proceed with the installation of the Virtio gues drivers. You can find a in-depth guide for this procee in the [Official Kubevirt Docs](https://kubevirt.io/user-guide/user_workloads/windows_virtio_drivers/).

After the install process completes, the VM will reboot and take you to the Out-Of-Box Experience (OOBE). From here we want to go into audit mode by pressing CTRL+SHIFT+F3 so that we can run sysprep to create a generalized installer image.

You can learn more about audit mode from the official Microsoft Docs:
- [Sysprep (Generalize) a Windows installation](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/sysprep--generalize--a-windows-installation?view=windows-11)
- [Boot Windows to Audit mode or OOBE](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/boot-windows-to-audit-mode-or-oobe?view=windows-11)

Once inside audit mode, prepare your base system as you see fit. I recommend:

1. Installing all remaining virtio drivers using the `virtio-win-guest-tools`application in the mounted in the `E:` drive
2. Install GPU drivers
3. Install the browser of your choice & configure search-engine
4. Install required apps like Steam, VLC, etc.. [Ninite](https://ninite.com/) is super helpful here.
5. Configure RDP settings
6. Setup Cloud-Base-Init
    - metadata service: `metadata_services=cloudbaseinit.metadata.services.nocloudservice.NoCloudConfigDriveService`





