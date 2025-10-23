#! /bin/bash

secrets=$(sops decrypt secrets.yml | yq -r '.secrets.jellyfin.data')

API_KEY=$(yq -r '.apiKey' <<< "$secrets")
CLIENT_ID=$(yq -r '.oidcClientId' <<< "$secrets")
CLIENT_SECRET=$(yq -r '.oidcClientSecret' <<< "$secrets")
CLIENT_ISSUER="https://id.bichls.dev"
PROVIDER_NAME=oidc
JELLYFIN_URL="https://jellyfin-10-242-20-170.lab-local.bichls.dev"

curl -v -X POST -H "Content-Type: application/json" -d "{\"oidEndpoint\": \"$CLIENT_ISSUER\", \"oidClientId\": \"$CLIENT_ID\", \"oidSecret\": \"$CLIENT_SECRET\", \"enabled\": true, \"enableAuthorization\": false, \"enableAllFolders\": false, \"roleClaim\": \"realm_access\", \"oidScopes\" : [\"\"]}" "$JELLYFIN_URL/sso/OID/Add/$PROVIDER_NAME?api_key=$API_KEY"
