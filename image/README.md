# vyshane/cassandra Docker Image

Extends the [official Cassandra image](https://hub.docker.com/_/cassandra/) with the addition of [dnsutils](https://packages.debian.org/jessie/dnsutils) (for the `dig` command) and a [custom entrypoint](https://github.com/vyshane/cassandra-kubernetes/blob/master/image/custom-entrypoint.sh) to configure seed nodes for the container.

Expects seed node IP addresses to be provided as DNS A records. You can provide the domain via the `PEER_DISCOVERY_SERVICE` environment variable. This seed discovery mechanism was designed to play nice with [Kubernetes headless services](http://kubernetes.io/v1.0/docs/user-guide/services.html#headless-services).
