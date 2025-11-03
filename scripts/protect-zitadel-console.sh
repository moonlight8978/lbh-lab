#! /bin/bash

secrets=$(sops decrypt secrets.yml | yq -r '.secrets.zitadel.children.misc')

PROJECT_ID=$(yq -r '.defaultProjectId' <<< "$secrets")
PAT=$(kubectl get secret -n application zitadel-iam-admin-pat -o yaml | yq -r '.data.pat' | base64 -d)

curl -L -X PUT "https://id.bichls.dev/management/v1/projects/$PROJECT_ID" \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H "Authorization: Bearer $PAT" \
--data-raw '{
  "name": "ZITADEL",
  "projectRoleAssertion": false,
  "projectRoleCheck": false,
  "hasProjectCheck": true,
  "privateLabelingSetting": "PRIVATE_LABELING_SETTING_UNSPECIFIED"
}'
