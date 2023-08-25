#!/bin/bash
# param 1: organization_name
# param 2: tenant_id

vault policy write $1_superadmin -<<EOF
path "$1/$2/*" {
  capabilities = ["create", "update", "patch", "read", "delete"]
}
path "organization/$1" {
  capabilities = ["create", update", "patch", "read", "delete"]
}
EOF

vault policy write $1_admin -<<EOF
path "$1/$2/*" {
  capabilities = ["create", "update", "patch", "read"]
}
path "organization/$1" {
  capabilities = ["create", "read"]
}
EOF

vault policy write $1_user -<<EOF
path "$1/$2/users/{{identity.entity.metadata.email}}/*" {
  capabilities = ["create", "update", "patch", "read", "delete"]
}
path "$1/$2/projects/{{identity.entity.metadata.project}}/*" {
  capabilities = ["create", "update", "patch", "read", "delete"]
}
path "organization/$1" {
  capabilities = ["read"]
}
path "$1/$2/platform/*" {
  capabilities = ["read"]
}
path "$1/$2/global/*" {
  capabilities = ["read"]
}
path "$1/$2/babylon/*" {
  capabilities = ["read"]
}
path "$1/$2/*" {
  capabilities = ["read"]
}
EOF
