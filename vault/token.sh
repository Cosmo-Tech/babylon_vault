#!/bin/bash

az vm run-command invoke \
        -g rg-vaultserver \
        -n vm-vault \
        --command-id RunShellScript \
        --scripts "export VAULT_ADDR=http://127.0.0.1:8200;vault operator init" \
        --output yaml >> response.yaml
yq '.value[0].message' response.yaml >> .unseal.yaml
cat .unseal.yaml
awk '$3 ~ /Token:/ {print "VAULT_TOKEN="$4}' .unseal.yaml >> $GITHUB_ENV