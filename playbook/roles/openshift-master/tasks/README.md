Issue with certs being recorded in etcd
---------------------------------------

Current github issue: https://github.com/openshift/origin/issues/8684#issuecomment-248626324

If the certs get changed out you need to remove the counterpart in etcd for now

    etcdctl ls --recursive | grep /openshift-infra.*controller.*token
