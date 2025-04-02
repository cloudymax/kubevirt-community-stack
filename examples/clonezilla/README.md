# Clonezilla

About:

Clonezilla is a partition and disk imaging/cloning program similar to True Image® or Norton Ghost®. It helps you to do system deployment, bare metal backup and recovery. Clonezilla saves and restores only used blocks in the hard disk. This increases the clone efficiency.


Limitations:

- The destination partition must be equal or larger than the source one.
- Differential/incremental backup is not implemented yet.
- Online imaging/cloning is not implemented yet. The partition to be imaged or cloned has to be unmounted.
- Due to the image format limitation, the image can not be explored or mounted. You can _NOT_ recovery single file from the image. However, you still have workaround to make it, read this.
- Recovery Clonezilla live with multiple CDs or DVDs is not implemented yet. Now all the files have to be in one CD or DVD if you choose to create the recovery iso file.


Official downloads page: https://clonezilla.org/downloads.php


## Usage

Clonzilla is perfect for capturing windows system images for re-deployment after they have been pre-loaded with drivers and tools, but not yet provisioned. (Think virtio drivers and cloud-base-init etc..).

- Create a non-uefi vm with a clonezilla ISO as the 1st boot device, and the disk you want to backup/clone as the 2nd or later boot device.

- Use virtctl or KubevirtManager to access the VNC interface of the VM

- Make a selection from the GRUB menu and boot the live-image

- Choose `Start Clonezilla`

- Choose `device-image work with disk or partitions using images`

- Choose a destination for you image, I find using the `s3_server` option easiest. Once this has been selected the networking will be enabled and you will be dropped into a root shell.

- run `systemctl enable ssh` and `systemctl restart ssh`

- run `passwd user` and create a password for the user account

- you can now ssh into them VM (if you enabled a load-balancer or port-forwarded the ssh port)

- create the `/root/.passwd-s3fs` credential file

- run `chmod 600 /root/.passwd-s3fs`

- back in the VNC session, run `exit` to return to the application
