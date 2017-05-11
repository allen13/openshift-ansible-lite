consul issues
-------------

If the consul cluster gets restarted all it once it will fail to elect a leader
on restarting.

Related issue: https://github.com/hashicorp/consul/issues/993

You must follow this procedure:

      On 2 of the 3 nodes

      $ consul leave

      $ rm -rf /var/consul/*

      $ sudo service consul-service restart

      $ consul join <3rd node IP address>

      On the 3rd node

      $ consul leave

      $ rm -rf /var/consul/*

      $ sudo service consul-service restart

      $ consul join <1st node IP address>
