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

## Alternatives?

Check out the [official Kubernetes Cassandra example](https://github.com/kubernetes/kubernetes/tree/master/examples/cassandra).

## Why did you create this project?

I wanted to reuse the [official Cassandra Docker image](https://hub.docker.com/_/cassandra/). My [Docker image](image/Dockerfile) extends the official Cassandra image with the addition dnsutils and a [custom entrypoint](image/custom-entrypoint.sh) that configures seed nodes for the container.

Seed node IP addresses are provided via DNS by a [headless Kubernetes service](cassandra-peer-service.yml).

