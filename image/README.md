# vyshane/cassandra

Identical to the [official Cassandra image](https://hub.docker.com/_/cassandra/) except for the addition of a [custom entrypoint](custom-entrypoint.sh) that configures seed nodes for the container before giving control back to the upstream entrypoint. Seed node IP addresses are provided via DNS by a [headless Kubernetes service](../cassandra-nodes-service.yml).
