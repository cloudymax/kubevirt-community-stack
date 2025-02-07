## Operating Systems which Support Cloud-init

Cloud-init is supported across a wide-range of OS's though I do not and cannot test all of them.
I only test on Ubuntu Server and Debian cloud-images.

Below is a list of all distros Cloud-init says it supports:

- AlmaLinux, Alpine Linux, AOSC OS, Arch Linux
- CentOS, CloudLinux, Container-Optimized OS
- Debian, DragonFlyBSD
- EuroLinux
- Fedora, FreeBSD
- Gentoo
- MarinerOS, MIRACLE LINUX
- NetBSD
- OpenBSD, openEuler, OpenCloudOS, OpenMandriva
- PhotonOS
- Red Hat Enterprise Linux, Rocky
- SLES/openSUSE
- TencentOS
- Ubuntu
- Virtuozzo

## Module List

Cloud-Init is module-based and now has a very large ecosystem of supported sofware, please be aware of the following:
  1. I do not aim to support all of them and only add the ones I need as I encounter a need for them.
  2. Some modules are somewat redundant as their functionality can be fully or mostly replaced by using the `write_files` module.
  3. PRs are welcome but you must provide proof of testing until such a time as automated tests can be written.


|Module|Status|
|:--|:--|

|Ansible||
|APK Configure||
|Apt Configure||
|Apt Pipelining||
|Bootcmd||
|Byobu||
|CA Certificates||
|Chef||
|Disable EC2 Instance Metadata Service||
|Disk Setup||
|Fan||
|Final Message||
|Growpart||
|GRUB dpkg||
|Install Hotplug||
|Keyboard||
|Keys to Console||
|Landscape||
|Locale||
|LXD||
|MCollective||
|Mounts||
|NTP||
|Package Update Upgrade Install||
|Phone Home||
|Power State Change||
|Puppet||
|Resizefs||
|Resolv Conf||
|Red Hat Subscription||
|Rsyslog||
|Runcmd||
|Salt Minion||
|Scripts Per Boot||
|Scripts Per Instance||
|Scripts Per Once||
|Scripts User||
|Scripts Vendor||
|Seed Random||
|Set Hostname||
|Set Passwords||
|Snap||
|Spacewalk||
|SSH||
|SSH AuthKey Fingerprints||
|SSH Import ID||
|Timezone||
|Ubuntu Drivers||
|Ubuntu Autoinstall||
|Ubuntu Pro||
|Update Etc Hosts||
|Update Hostname||
|Users and Groups||
|Wireguard||
|Write Files||
|Yum Add Repo||
|Zypper Add Repo||
