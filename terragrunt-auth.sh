#!/bin/sh

set -eu

sops decrypt secrets.yml | yq eval -o json
