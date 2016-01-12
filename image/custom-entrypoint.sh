#!/bin/bash
#
# Configure Cassandra seed nodes.

my_ip=$(hostname --ip-address)

CASSANDRA_SEEDS=$(host $PEER_DISCOVERY_SERVICE | \
    grep -v "not found" | \
    grep -v $my_ip | \
    sort | \
    head -2 | xargs | \
    awk '{print $4}')

if [ ! -z "$CASSANDRA_SEEDS" ]; then
    export CASSANDRA_SEEDS
fi

/docker-entrypoint.sh "$@"
