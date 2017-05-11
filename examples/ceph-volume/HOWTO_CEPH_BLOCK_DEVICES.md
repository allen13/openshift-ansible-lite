How to create persistent storage for openshift with Ceph
========================================================

Overview
--------

Openshift uses the concept of a persistent volume(PV), and a claim to use a persistent volume(PVC). A pod(container) will then specify a PVC to use for persistent storage. The storage must first exist on the ceph cluster that the PV points to. In short:
Ceph block device -> PV -> PVC -> Pod

Ceph Overview
-------------

Ceph uses pools that storage can be organized in. For Openshift we will be using block device storage with ceph. By default ceph creates a pool named 'rbd' that can be used for block devices. It is acceptable to create your block devices in the default 'rbd' pool.

Getting Started
---------------

Create a block device on ceph with a size of 1024MB
```
rbd create --size 1024 rbd/ceph-1g-0000
```

You can now list your block devices and get information about them
```
rbd ls
rbd info ceph-1g-0000
rbd du
ceph df
```

ADDITIONAL INFO: To resize a block device
```
rbd resize --size 2048 ceph-1g-0000
```

ADDITIONAL INFO: To remove a block device
```
rbd rm ceph-1g-0000
```

Now we can create our Openshift manifest to use this block device. We first need to edit our manifest to point to our new block device located at 'rbd/ceph-1g-0000'. The example in this directory is a list manifest of both the PV and PVC. You will change the following
* metadata -> name (both PV and PVC)
* storage size (both PV and PVC)
* rbd -> image - this is the name of the block device you created
* rbd -> monitors - this is the list of monitor ip addresses

You can get the list of monitor ip addresses with
```
for i in "$(cat /etc/ceph/ceph.conf | grep mon_addr)"; do echo "$i" | awk '{print $3}'; done
```
or
```
ceph mon_status | python -m json.tool
```

Create your test project
```
oc create -f test-project.yml
```

Create the PV/PVC - The 'n' parameter specifies the project/namespace in openshift to create it in
```
oc create -n test -f volume.yml
```

We need to add ceph client credentials to your Openshift project before it can use ceph storage. This ansible playbook places a copy of them in /root/origin-test/ceph-secret.yml
```
oc create -n test -f /root/origin-test/ceph-secret.yml
```

If you look in the Openshift gui you should now see your PVC in your project under Browse -> storage

There is a test mysql container in pod.yml in this directory you can use to now test your storage. The pod.yml persistentVolumeClaim -> claimName needs to match the volume.yml PVC metadata -> name. You can start this test mysql container with
```
oc create -n test -f pod.yml
```

Testing Ceph block devices outside of Openshift
-----------------------------------------------

To play with a block device on your host manually, first follow the steps above to 'rbd create' your block device in the ceph cluster. Next you map the block device onto your local system. It will output the block device name
```
rbd map ceph-1g-0000
```

Show mapped ceph block devices
```
rbd showmapped
```

You can now use the block device as storage. Typically you will format it with a filesystem then mount it somewhere
```
mkfs.xfs /dev/rbd0
mkdir -p /mnt/ceph-1g-0000
mount /dev/rbd0 /mnt/ceph-1g-0000
```
NOTE: Creating partitions on the ceph block device is optional, and not really needed since you can create named block devices on the fly with ceph.

Once you are done with your block device mount, unmout and unmap it
```
umount /mnt/ceph-1g-0000
rbd unmap /dev/rbd0
```
