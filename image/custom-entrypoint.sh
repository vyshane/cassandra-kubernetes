#!/bin/bash
#
# Configure Cassandra seed nodes.

# Give Kubernetes time to add the new pod to the cassandra peer discovery service before we query DNS
sleep 5

my_ip=$(hostname --ip-address)

CASSANDRA_SEEDS=$(host $PEER_DISCOVERY_SERVICE | \
    grep -v "not found" | \
    grep -v "connection timed out" | \
    grep -v $my_ip | \
    sort | \
    head -3 | \
    awk '{print $4}' | \
    xargs)

if [ ! -z "$CASSANDRA_SEEDS" ]; then
    export CASSANDRA_SEEDS
fi

/docker-entrypoint.sh "$@"
