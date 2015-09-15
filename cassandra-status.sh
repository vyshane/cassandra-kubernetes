#!/bin/bash
#
# Output Cassandra cluster and pod status

find_cassandra_pods="kubectl get pods -l name=cassandra"

first_running_seed=$($find_cassandra_pods --no-headers | \
    grep Running | \
    grep 1/1 | \
    head -1 | \
    awk '{print $1}')

cluster_status=$(kubectl exec $first_running_seed \
    -c cassandra \
    -- nodetool status -r)

echo
echo "  C* Node      Kubernetes Pod"
echo "  -------      --------------"

while read -r line; do
    node_name=$(echo $line | awk '{print $1}')
    status=$(echo "$cluster_status" | grep $node_name | awk '{print $1}')

    long_status=$(echo "$status" | \
        sed 's/U/  Up/g' | \
	sed 's/D/Down/g' | \
	sed 's/N/|Normal /g' | \
	sed 's/L/|Leaving/g' | \
	sed 's/J/|Joining/g' | \
	sed 's/M/|Moving /g')

    : ${long_status:="            "}

    echo "$long_status   $line"
done <<< "$($find_cassandra_pods)"

echo
