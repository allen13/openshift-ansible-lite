#!/bin/bash
# This is a seek and destroy script for a hardcoded kubernetes iptables rule.
# The rule is injected at the top of the INPUT chain in order to allow access
# to non-local nodeports. We do not want this behaviour because all nodes
# have an interface on the public internet with a default drop policy. We
# manage our own list of whitelisted CIDR's to allow.

remove_nodeport_allow_rule() {
    # retrieve the rule number, blank string if it does not exist
    # this should not have any race condition because we delete the specific rule instead of a rule number
    local RULENUM=$(/sbin/iptables --line-numbers -nL | grep 'Ensure that non-local NodePort traffic can flow' | awk '{print $1}')

    # remove the rule if it exists
    if [ ! -z $RULENUM ]; then
        /sbin/iptables -D INPUT -m comment --comment "Ensure that non-local NodePort traffic can flow" -j KUBE-NODEPORT-NON-LOCAL
    fi
}

for i in {1..59}; do
    remove_nodeport_allow_rule
    sleep 1
done
