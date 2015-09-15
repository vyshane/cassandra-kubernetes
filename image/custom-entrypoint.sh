#!/bin/bash
#
# Configure Cassandra seed nodes so that we can join the cluster.

my_ip=$(hostname --ip-address)

# cassandra-nodes is a headless Kubernetes service that gives us the
# IP addresses of our current cassandra nodes.
seeds=$(dig cassandra-nodes.default.cluster.local +short | \
    grep -v $my_ip | \
    sort | \
    head -2 | xargs | \
    sed -e 's/ /,/g')

: ${seeds:=$my_ip}

sed -ri 's/(- seeds:) "127.0.0.1"/\1 "'"$seeds"'"/' "$CASSANDRA_CONFIG/cassandra.yaml"

# Upstream entrypoint
source /docker-entrypoint.sh
