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

## Auto-unseal Steps

1. Set this location as your working directory

1. Set ssh_keygen (public_key)

    ```bash
    $ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    $ cat ~/.ssh/id_rsa.pub
    # Then select and copy the contents of the id_rsa.pub file
    # displayed in the terminal to your clipboard
    # Then assign this key to the 'public_key' variable in terraforms.tfvars file
    ```

1. Provide Azure credentials in the `terraform.tfvars`

    ```bash
    tenant_id = ""
    client_id = ""
    client_secret = ""
    subscription_id = ""
    public_key = ""
    ```

1. Setup new configuration

    A platform configuration contains differents config files:

    - acr.json
    - adx.json
    - adt.json
    - api.json
    - app.json
    - azure.json
    - babylon.json
    - github.json
    - platform.json
    - powerbi.json
    - webapp.json
    
    <br>
    You will find the template in `vault/config` directory.

    You need to create a directory per platform and add the command `upload.sh` in section `upload configuration`.

    ```bash
    - name: upload configuration
      run: |
        chmod +x vault/upload.sh
        cd vault/
        ./upload.sh cosmotech ${{vars.TENANT_ID}} <platform_1> # vault/config/platform_1
        ./upload.sh cosmotech ${{vars.TENANT_ID}} <platform_2> # vault/config/platform_2
        
        ...

        ./addpolicies.sh cosmotech ${{vars.TENANT_ID}}
    ```

<br>

1. Run the Terraform commands:

    ```bash
    $ terraform init
    $ terraform plan -out tfvaultplan
    $ terraform apply tfvaultplan
    ...
    Outputs:

    
    VAULT_ADDR=http://ip_address:8200
    ssh azureuser@ip_address
    ```
    