#!/usr/bin/env python2
# yum install python-sh -y
# This script will display the contents of all data in an openshift secret
# Usage: getsecret.py [secretname]

import json
import base64
import sys
from sh import oc

secret = json.loads(oc.get.secret(sys.argv[1], o="json").stdout)

for dataname, data in secret['data'].iteritems():
    print "===== Data: {0} =====".format(dataname)
    print base64.b64decode(data)
    print "===== end of {0} =====".format(dataname)
