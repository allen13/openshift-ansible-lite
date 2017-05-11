import yaml


def get_empty_disks(ansible_devices):
    empty_disks = [k for k, v in ansible_devices.iteritems() if not v['partitions']]
    return empty_disks

class FilterModule (object):
    def filters(self):
        return {"get_empty_disks": get_empty_disks}
