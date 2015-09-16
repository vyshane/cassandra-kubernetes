#!/bin/bash
#
# Configure Cassandra seed nodes.

my_ip=$(hostname --ip-address)

CASSANDRA_SEEDS=$(dig $PEER_DISCOVERY_DOMAIN +short | \
    grep -v $my_ip | \
    sort | \
    head -2 | xargs | \
    sed -e 's/ /,/g')

export CASSANDRA_SEEDS

/docker-entrypoint.sh "$@"
