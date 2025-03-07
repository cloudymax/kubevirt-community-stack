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

Clonzilla is perfect for capturing windows system images for re-deployment after they have been pre-loaded with drivers and tools, but not yet provisioned. (Think virtio drivers and cloud-base-init etc..). While Clonezilla supports saving data to S3, I prefer to use it with SeaweedFS and therefor have a customized image containing the seaweedFS cli for mounting remote-storage as FUSE.





