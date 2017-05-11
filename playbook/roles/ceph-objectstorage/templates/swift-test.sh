#!/bin/bash
# Written by: Jason Gardner

# Set your object storage credentials
APIUSER='{{ ceph_objectstorage_credentials.swift_keys[0].user }}'
APIKEY='{{ ceph_objectstorage_credentials.swift_keys[0].secret_key }}'
URL='http://{{ openshift_ceph_rgw_endpoint }}:8080/auth/1.0'

# Perform Auth
doAuth() {
  AUTH=$(curl -s -i -H "X-Auth-User: $APIUSER" -H "X-Auth-Key: $APIKEY" $URL)
  OSCODE=$(echo "$AUTH" | grep 'HTTP' | tr -d '\r' | awk '{print $2}')
  OSURL=$(echo "$AUTH" | grep 'X-Storage-Url' | tr -d '\r' | awk '{print $2}')
  OSTOKEN=$(echo "$AUTH" | grep 'X-Storage-Token' | tr -d '\r' | awk '{print $2}')
  unset AUTH
}

# Perform Container Listing
listContainers() {
  curl -s -H "X-Auth-Token: $OSTOKEN" $OSURL
}

echo ::Object Storage Test Tool::
echo Username: $APIUSER

# Do Auth
echo
echo Command used for AUTH:
echo 'curl -s -i -H "X-Auth-User: '$APIUSER'" -H "X-Auth-Key: '$APIKEY'"' $URL
doAuth
echo
if [ $OSCODE -eq 204 ]; then
  echo Authentication Succeeded!
  echo Got API URL: $OSURL
  echo Got API Token: $OSTOKEN
else
  echo Authentication Failed!
  exit 1
fi

# Do Containter List
echo
echo First 10 Object Storage Containers:
echo $(listContainers) | head -n 10
echo
echo Command to perform operations:
echo 'curl -s -H "X-Auth-Token: '$OSTOKEN'"' $OSURL
