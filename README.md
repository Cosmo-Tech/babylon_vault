# Auto-unseal using Azure Key Vault

These assets are provided to perform the tasks described in the [Auto-unseal with Azure Key Vault](https://learn.hashicorp.com/vault/operations/autounseal-azure-keyvault) guide.

---

## Prerequisites

- Microsoft Azure account
- [Terraform installed](https://www.terraform.io/downloads.html) and ready to use

<br>

**Terraform Azure Provider Prerequisites**

A ***service principal*** is an application within Azure Active Directory which
can be used to authenticate. Service principals are preferable to running an app
using your own credentials. Follow the instruction in the [Terraform
documentation](https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_certificate.html)
to create a service principal and then configure in Terraform.

Add permissions:
- Microsoft Graph: 
    * Directory.ReadWrite.All (delegated permissions) 
    * Application.ReadWrite.All (Applications permissions)

Tips:

- **Subscription ID**: Navigate to the [Subscriptions blade within the Azure
 Portal](https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade)
 and copy the **Subscription ID**  

- **Tenant ID**: Navigate to the [Azure Active Directory >
 Properties](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Properties)
 in the Azure Portal, and copy the **Directory ID** which is your tenant ID  

- **Client ID**: Same as the [**Application
 ID**](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ApplicationsListBlade)

- **Client secret**: The [password
 (credential)](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ApplicationsListBlade)
 set on your application

> **IMPORTANT:** Ensure that your Service Principal has appropriate permissions to provision virtual machines, networks, as well as **Azure Key Vault**. Refer to the [Azure documentation](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal).

## Create a key ssh

### Step 1

```bash
cd ~/.ssh
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
cat ~/.ssh/id_rsa.pub
# Then select and copy the contents of the id_rsa.pub file
# displayed in the terminal to your clipboard
```

### Step 2

Go to https://github.com/Cosmo-Tech/babylon_vault/settings/variables/actions and update deploy values

* `CLIENT_ID`
* `DOMAIN_LABEL`
* `PUBLIC_KEY`
* `RESOURCE_GROUP`
* `SUBSCRIPTION_ID`
* `TENANT_ID`
* `TENANT_NAME`

Go to https://github.com/Cosmo-Tech/babylon_vault/settings/secrets/actions and update secret value (if needed)

* `CLIENT_SECRET`  

### Step 3

Run workflow

### Post-run

Go to https://github.com/Cosmo-Tech/babylon_vault/actions. In the last workflow, go to '`run vault init script`' step and copy '`Initial Root Token`' to access the deployed vault in Azure.