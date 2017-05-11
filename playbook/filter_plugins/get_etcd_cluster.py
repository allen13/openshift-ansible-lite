from ansible import errors
import json


def get_etcd_cluster(host_vars, group, port='2380', include_hostname=True):
    if type(group) != list:
        raise errors.AnsibleFilterError("|failed expects a List")

    hosts_in_group = []
    for host in group:
        hosts_in_group.append(host_vars[host])

    if include_hostname:
        formatted_hosts = map((lambda host: host['inventory_hostname'] + '=http://' + host['private_ip'] + ':2380'), hosts_in_group)
    else:
        formatted_hosts = map((lambda host: 'http://' + host['private_ip'] + ':' + port), hosts_in_group)

    return formatted_hosts

class FilterModule (object):
    def filters(self):
        return {"get_etcd_cluster": get_etcd_cluster}
