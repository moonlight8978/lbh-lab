#! /bin/bash

KIND=$1

if [ "$KIND" == "secret" ]; then
    docker run --rm glanceapp/glance secret:make
elif [ "$KIND" == "pw" ]; then
    docker run --rm glanceapp/glance password:hash "${@:2}"
else
    echo "Invalid kind specified. Supported kinds: secret, pw"
    exit 1
fi
