#!/bin/bash

branch=`git rev-parse --abbrev-ref HEAD`
if [ "$branch" == master ]; then
    branch=latest
fi

docker build -q -t vyshane/cassandra:$branch .
