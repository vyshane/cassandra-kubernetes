# vyshane/cassandra Docker Image

Extends the [official Cassandra image](https://hub.docker.com/_/cassandra/) with the addition of dnsutils and a [custom entrypoint](custom-entrypoint.sh) to configure seed nodes for the container. Seed node IP addresses are provided via DNS by a [headless Kubernetes service](../cassandra-peer-service.yml).
