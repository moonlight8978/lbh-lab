#! /bin/bash

docker run --rm solidtime/solidtime:latest php artisan self-host:generate-keys
