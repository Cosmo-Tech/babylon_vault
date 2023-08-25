#!/bin/bash
# param 1: organization_name
# param 2: tenant_id
# param 3: platform

vault secrets enable -path=$1 kv
vault secrets enable -path=organization kv
vault kv put -mount=organization $1 tenant=$2
vault kv put -mount=$1 $2/babylon/config/$3/acr @config/$3/acr.json
vault kv put -mount=$1 $2/babylon/config/$3/adt @config/$3/adt.json
vault kv put -mount=$1 $2/babylon/config/$3/adx @config/$3/adx.json
vault kv put -mount=$1 $2/babylon/config/$3/api @config/$3/api.json
vault kv put -mount=$1 $2/babylon/config/$3/app @config/$3/app.json
vault kv put -mount=$1 $2/babylon/config/$3/azure @config/$3/azure.json
vault kv put -mount=$1 $2/babylon/config/$3/babylon @config/$3/babylon.json
vault kv put -mount=$1 $2/babylon/config/$3/github @config/$3/github.json
vault kv put -mount=$1 $2/babylon/config/$3/platform @config/$3/platform.json
vault kv put -mount=$1 $2/babylon/config/$3/powerbi @config/$3/powerbi.json
vault kv put -mount=$1 $2/babylon/config/$3/webapp @config/$3/webapp.json