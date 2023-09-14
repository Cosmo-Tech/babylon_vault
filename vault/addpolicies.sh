#!/bin/bash
# param $1: organization_name
# param $2: tenant_id

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
EOF

vault policy write $1_user -<<EOF
path "$1/$2/users/{{identity.entity.metadata.email}}/*" {
  capabilities = ["create", "update", "patch", "read", "delete", "list"]
}
path "$1/$2/projects/{{identity.entity.metadata.project}}/*" {
  capabilities = ["create", "update", "patch", "read", "delete", "list"]
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
