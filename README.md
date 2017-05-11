openshift-ansible-lite
=======================

A [Kubernetes](http://kubernetes.io/docs/)/[Openshift](https://docs.openshift.org/latest/welcome/index.html) driven container cloud. This is a simplified version of [openshift-ansible](https://github.com/openshift/openshift-ansible).

Setup
-----

Install [Virtualbox](https://www.virtualbox.org/wiki/Downloads), [Vagrant](http://www.vagrantup.com/downloads), and [Ansible](http://docs.ansible.com/ansible/intro_installation.html) on your local machine.

Running in vagrant
------------------

    vagrant up
    bin/provision_development
    go to https://192.0.2.201:8443 login: admin password: admin

Destroying
----------

    bin/destroy

Persistent Storage
------------------

By nature containers do not have persistent storage. Their data is lost when a container exits. We have implemented a [Ceph cluster](http://docs.ceph.com/docs/master/architecture/) for a place to put data that should be saved. Typical use case for persisitent storage would be something like a mysql database so data is kept. Primarily we are using ceph block devices formatted as xfs(for wide range of compatibility/performance) that OpenShift can attach to a container anywhere in its filesystem. For a quick intro to Ceph and common cli commands, check out [CEPH.md](CEPH.md). For a demo on how to provision a ceph block device manually and add it to Openshift for use with your project, check out [examples/ceph-volume/HOWTO_CEPH_BLOCK_DEVICES.md](examples/ceph-volume/HOWTO_CEPH_BLOCK_DEVICES.md)

Running Java based services
---------------------------

When running Java based services in a container you may want to set this environment variable if your memory usage is erratic: MALLOC_ARENA_MAX=4 This effect is particularly pronounced when running on a large production machine where there are a lot of processors and RAM. You can read more about what is going on on in [this github issue](https://github.com/docker/docker/issues/15020#issuecomment-225309243). Also [this blog](https://siddhesh.in/posts/malloc-per-thread-arenas-in-glibc.html) describes exactly what these mysterious thread arena contraptions are.
