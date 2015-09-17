# Multi-node [Cassandra](http://cassandra.apache.org) Cluster on [Kubernetes](http://kubernetes.io/)

## Creating a Cluster

You will need to bring your own Kubernetes. A quick and easy way to setup Kubernetes locally is [via Docker Compose](https://github.com/vyshane/docker-compose-kubernetes). Once you have Kubernetes up and running:

```sh
./start-cassandra.sh
```

This will create a Kubernetes pod containing a single Cassandra node. You can use the [`cassandra-status.sh`](cassandra-status.sh) convenience script to see that the node comes up:

```sh
./cassandra-status.sh 

  C* Node      Kubernetes Pod
  -------      --------------
               NAME              READY     STATUS    RESTARTS   AGE
  Up|Normal    cassandra-kxa18   1/1       Running   0          1m
```

## Scaling the Cluster

To launch more Cassandra nodes and have them join the cluster, simply scale the [Cassandra replication controller](cassandra-replication-controller.yml):

```sh
kubectl scale rc cassandra --replicas=2
```

A new pod is created...

```sh
./cassandra-status.sh                                                                                                                                                                                                                                                                                                                                          

  C* Node      Kubernetes Pod
  -------      --------------
               NAME              READY     STATUS                                                     RESTARTS   AGE
               cassandra-cnvzm   0/1       Image: vyshane/cassandra is ready, container is creating   0          8s
  Up|Normal    cassandra-kxa18   1/1       Running                                                    0          6m
```

... and it automatically joins the cluster.

```sh
./cassandra-status.sh 

  C* Node      Kubernetes Pod
  -------      --------------
               NAME              READY     STATUS    RESTARTS   AGE
  Up|Joining   cassandra-cnvzm   1/1       Running   0          29s
  Up|Normal    cassandra-kxa18   1/1       Running   0          7m
```

```sh
./cassandra-status.sh 

  C* Node      Kubernetes Pod
  -------      --------------
               NAME              READY     STATUS    RESTARTS   AGE
  Up|Normal    cassandra-cnvzm   1/1       Running   0          1m
  Up|Normal    cassandra-kxa18   1/1       Running   0          8m
```

## Connecting to Cassandra

You can connect to Cassandra from any pod in the Kubernetes cluster via the IP address of the [Cassandra service](cassandra-service.yml). To obtain the IP address:

```sh
kubectl describe svc cassandra
```

If the [Kubernetes DNS addon](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/dns) is active, you can also connect to the service through the `cassandra` hostname.

## Configuration Options

The following environment variables can be configured in the [Cassandra replication controller definition](cassandra-replication-controller.yml):

```sh
env:
  - name: CASSANDRA_CLUSTER_NAME
    value: Cassandra
  - name: CASSANDRA_DC
    value: DC1
  - name: CASSANDRA_RACK
    value: Kubernetes Cluster
  - name: CASSANDRA_ENDPOINT_SNITCH
    value: GossipingPropertyFileSnitch
```

## Alternatives?

The Kubernetes project has a [Cassandra example](https://github.com/kubernetes/kubernetes/tree/master/examples/cassandra) that uses a custom seed provider for seed discovery. The example makes use of a Cassandra Docker image from `gcr.io/google_containers`.

## Why Did You Create this Project?

I wanted a solution based on the [official Cassandra Docker image](https://hub.docker.com/_/cassandra/). My [Docker image](image/) extends the official Cassandra image with the addition of [dnsutils](https://packages.debian.org/jessie/dnsutils) (for the `dig` command) and a [custom entrypoint](image/custom-entrypoint.sh) that configures seed nodes for the container. Seed node IP addresses are provided via DNS by a [headless Kubernetes service](cassandra-peer-service.yml).

## Next Steps

* [Configure Cassandra to use authentication](http://docs.datastax.com/en/cassandra/2.2/cassandra/configuration/secureConfigNativeAuth.html)
