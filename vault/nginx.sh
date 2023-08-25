#!/bin/bash

az vm run-command invoke \
        -g rg-vaultserver \
        -n vm-vault \
        --command-id RunShellScript \
        --scripts "cd /home/azureuser; ./nginx_init.sh" \
        --output yaml >> response.yaml
        
yq '.value[0].message' response.yaml >> .unseal.yaml
cat .unseal.yaml