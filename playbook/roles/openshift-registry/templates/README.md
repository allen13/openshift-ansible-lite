#### Setup registry with swift backend

radosgw-admin user create --uid=registry --display-name=registry
radosgw-admin subuser create --uid=registry --subuser=registry:swift --access=full

Look for swift_keys in the response:
{
    ....
    "swift_keys": [
        {
            "user": "registry:swift",
            "secret_key": "n0qDR4EeVPGn8MeMj0FqXNERZ2dGEAPOWqmdQBsc"
        }
    ],
    ...
}

Override the openshift_registry_swift/password in ansible to the swift_keys["secret_key"]
You can also change the other swift settings as well

  openshift_registry_swift:
    username: registry:swift
    password: OVERRIDE PASSWORD HERE
    authurl: http://ceph-rgw-v1.ceph.svc.{{ openshift_dns_domain }}:8080/auth
    container: registry

Override the openshift_registry_backend to be swift-based

  openshift_registry_backend: swift-based

Remove the old registry-config secret

  oc delete secrets registry-config

Re-run the ansible deploy. You can use the openshift-registry tag

FINISH
