#! /bin/bash

# https://oauth2-proxy.github.io/oauth2-proxy/configuration/overview/
dd if=/dev/urandom bs=32 count=1 2>/dev/null | base64 | tr -d -- '\n' | tr -- '+/' '-_' ; echo
