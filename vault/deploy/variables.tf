# ---------------------------
# Azure Key Vault
# ---------------------------
variable "tenant_id" {
  default = ""
}

variable "key_name" {
  description = "Azure Key Vault key name"
  default     = "generated-key"
}

variable "location" {
  description = "Azure location where the Key Vault resource to be created"
  default     = "uksouth"
}

variable "environment" {
  default = "servervault"
}

# ---------------------------
# Virtual Machine
# ---------------------------
variable "public_key" {
  default = ""
}

variable "subscription_id" {
  default = ""
}

variable "client_id" {
  default = ""
}

variable "client_secret" {
  default = ""
}

variable "vm_name" {
  default = "vm-vault"
}

variable "vault_version" {
  default = "1.14.1"
}

variable "resource_group_name" {
  default = "rg-vaultserver"
}

variable "platform" {
  default = "dev"
}

variable "domain_label" {
  default = "cosmovault"
}

variable "email" {
  default = "nibaldo.donoso@cosmotech.com"
}

