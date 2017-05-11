CEPH cheat sheet
================

Overview
--------

Ceph is a cluster storage designed to be run on commodity hardware. You can set the number of replicas of each object across the cluster for your needs. You can think of it as a better RAID across a datacenter. It is self healing; if nodes go down it will automatically replicate data to other nodes to keep the number of replicas up. It gets faster the more storage nodes you throw at it.

With Ceph you get 3 types of storage by default, all on the same storage backend:
* Block Storage (Typically disks for VMs/Containers/Diskless systems)
* Object Storage (Cloud storage for your applications)
* Cephfs cluster aware filesystem (mountable, similar to mounting NFS/Samba)

There are also apis to create your own programmable storage backed by ceph.

Terminology
-----------

* MON - Monitor. These nodes keep track of the state of the cluster as a whole. They are also the endpoint that all cluster nodes talk to, and the endpoint your ceph client talks to when using the cluster.
* OSD - Object Storage Daemon. Ceph uses objects underneath for storage of all things. These are the nodes that handle storage of data on a specific disk. One daemon is run per disk/directory for storage, so you can have 5 running on a node with 5 disks.
* MDS - MetaData Server. This is only used if you need the cephfs cluster filesystem. This stores details of filenames/permissions/etc for the filesystem. An MDS also needs a physical storage location(directory), but not a lot of space.
* RGW - Rados GateWay. This daemon provides Openstack Swift and Amazon S3 compatible RESTful api endpoints to use the ceph cluster as object storage.

Monitoring / Health
-------------------

Overall cluster health - This shows the number of mon, osd, mds nodes.
The first number is the amount configured. UP means that node is online, IN means it has joined the cluster
```
ceph -s
```

Watch the status of a cluster
```
ceph -w
```

Watch the status of a cluster with debug messages for better troubleshooting
```
ceph --watch-debug
```

Show amount of storage used across cluster pools
```
ceph df
```

Show status of monitors
```
ceph mon_status | python -m json.tool
```

Short version showing the number of monitors
```
ceph mon stat
```

Show amount of storage used on each OSD daemon
```
ceph osd df
```

List pools
```
ceph osd pool ls
```

Display per pool placement and replication level
```
ceph osd dump | grep 'replicated size'
```

Change the number of replicas in a pool
```
ceph osd pool set [pool name] size 2
```

Set pool placement group size
```
ceph osd pool set [pool name] pg_num 512
ceph osd pool set [pool name] pgp_num 512
```

Display rbd images in the default rbd pool
```
rbd ls
```

Print rbd images in default rbd pool with sizes
```
unset BLOCK; for i in $(rbd ls); do BLOCK=$(printf "$BLOCK\n$(echo -n $i': '; rbd info $i | grep size | awk '{print $2,$3}')"); done; echo "$BLOCK" | column -t
```

Get rados statistics
```
rados df
```

Show state of monitor map
```
monmaptool --print /tmp/monmap
```

Remove node from monitor map
```
monmaptool --rm [node name] /tmp/monmap
```

Add node to monitor map
```
monmaptool --add [node name] /tmp/monmap
```

Adding / Removing nodes
-----------------------

Remove monitor from cluster. First stop it
```
ceph mon remove [mon name]
```

Removing osds
-------------

Get the down osds name you want to remove
```
ceph osd dump
```
Mark it of the cluster
```
ceph osd out 42
```
Mark it down
```
ceph osd down 42
```
Remove the osd from the crush map so it no longer receives data
```
ceph osd crush remove osd.42
```
Delete the authentication key for the osds
```
ceph auth del osd.42
```
Remove the osd from the cluster
```
ceph osd rm 42
```

Block Devices
-------------

Create a new pool
```
rados mkpool mypool
```

Create block device (the size is in megabytes)
```
rbd create --size 1024 mypool/testdevice
```

Misc
----

Set crush tunables to the default optimal tweaks for the current version of ceph-osd
```
ceph osd crush tunables optimal
```

THIS DOCUMENT IS STILL A WORK IN PROGRESS
