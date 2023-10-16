#!/bin/bash
# param $1: tenant_name
# param $2: tenant_id

# enable path
vault secrets enable -path=$1 -version=1 kv
vault secrets enable -path=organization -version=1 kv
vault kv put -mount=organization $1 tenant=$2

# add policies
vault auth enable -path=userpass-$1 userpass
vault policy write $1_superadmin -<<EOF
path "$1/$2/*" {
  capabilities = ["create", "update", "patch", "read", "delete", "list"]
}
path "organization/$1" {
  capabilities = ["create", "update", "patch", "read", "delete", "list"]
}
path "$1/*" {
  capabilities = ["create", "update", "patch", "read", "delete", "list"]
}
path "auth/userpass-$1/users/*" {
  capabilities = ["update"]
  allowed_parameters = {
    "password" = []
  }
}
EOF

vault policy write $1_admin -<<EOF
path "$1/$2/*" {
  capabilities = ["create", "update", "patch", "read", "list"]
}
path "organization/$1" {
  capabilities = ["create", "update", "patch", "read", "list"]
}
path "$1/*" {
  capabilities = ["create", "update", "patch", "read", "list"]
}
path "auth/userpass-$1/users/*" {
  capabilities = ["update"]
  allowed_parameters = {
    "password" = []
  }
}
EOF

accessor=$(vault auth list | awk '$1 ~ /'$1'/ {print $3}' -)

vault policy write $1_user -<<EOF
path "$1/$2/users/{{identity.entity.metadata.email}}/*" {
  capabilities = ["create", "update", "patch", "read", "delete", "list"]
}
path "$1/$2/projects/{{identity.entity.metadata.project}}/*" {
  capabilities = ["create", "update", "patch", "read", "delete", "list"]
}

path "auth/userpass-$1/users/{{identity.entity.aliases.$accessor.name}}" {
  capabilities = ["update"]
  allowed_parameters = {
    "password" = []
  }
}

path "organization/$1" {
  capabilities = ["read", "list"]
}
path "$1/$2/platform/*" {
  capabilities = ["read", "list"]
}
path "$1/$2/global/*" {
  capabilities = ["read", "list"]
}
path "$1/$2/babylon/*" {
  capabilities = ["read", "list"]
}
path "$1/$2/*" {
  capabilities = ["read", "list"]
}
path "$1/*" {
  capabilities = ["read", "list"]
}
EOF