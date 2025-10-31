#! /bin/sh

docker run --rm alpine:latest sh -c 'tr -dc A-Za-z0-9 </dev/urandom | head -c 32'
