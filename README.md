# GitHub Actions for deploying a 'certified' Azure Storage Account

## Automate your GitHub workflows using Azure Actions

[GitHub Actions](https://help.github.com/en/articles/about-github-actions)  gives you the flexibility to build an automated software development lifecycle workflow.

This Github Action is part of a blog post called "Comparing Azure DevOps Extension Release tasks with Github Action"

# GitHub Action for Azure Storage Account

With the Github Action for Azure Storage Account you can deploy and remove an Azure Storage Account, with the embedded security control to have all data being encrypted during transit. This Github Action can be used in your Github workflow. A prerequisite for this Github Action is having a Azure Subscription and a Resource Group created before running this Github Action.

Get started today with a [free Azure account](https://azure.com/free/open-source)!

This repository contains GitHub Action for [Azure Storage Account](https://github.com/stefanstranger/azure-storageaccount-action/blob/master/action.yml)

## Sample workflows that uses Azure Storage Account Github Action

```yaml

# File: .github/workflows/deploy.yml

name: Deploy-Azure-Storage-Account

on: [push]

jobs:
  deploy:
    name: Deploy
    runs-on: ubuntu-latest
    steps:
      - name: Deploy Azure Storage Account
        uses: stefanstranger/azure-storageaccount-action@master
        with:
          action: "createStorageAccount"
          ServiceConnection: "SERVICECONNECTION"
          StorageAccountName: "githubactiondemosa"
          ResourceGroupName: "ghactiondemo-rg"
          Location: "westeurope"
          AccountType: "Standard_LRS"
          AccessTier: "Cool"
        env: # Github Secret stored as Environment variable
          SERVICECONNECTION: ${{ secrets.AZURE_CREDENTIALS}}


```

```yaml

# File: .github/workflows/remove.yml

name: Remove-Azure-Storage-Account

on: [push]

jobs:
  deploy:
    name: Remove
    runs-on: ubuntu-latest
    steps:
      - name: Remove Azure Storage Account
        uses: stefanstranger/azure-storageaccount-action@master
        with:
          action: "removeStorageAccount"
          ServiceConnection: "SERVICECONNECTION"
          ResourceGroupName: "ghactiondemo-rg"
          StorageAccountName: "githubactiondemosa"
        env: # Github Secret stored as Environment variable
          SERVICECONNECTION: ${{ secrets.AZURE_CREDENTIALS}}


```

## Configure Azure credentials:

To fetch the credentials required to authenticate with Azure, run the following command to generate an Azure Service Principal (SPN) with Contributor permissions:

```PowerShell
#region Login to Azure
Add-AzAccount
#endregion
 
#region Select Azure Subscription
$subscription = 
(Get-AzSubscription |
    Out-GridView `
        -Title 'Select an Azure Subscription ...' `
        -PassThru)
 
Set-AzContext -SubscriptionId $subscription.subscriptionId -TenantId $subscription.TenantID
#endregion

#region create SPN with Password
$PlainPassword = "[enter password]"
$Password = ConvertTo-SecureString $PlainPassword  -AsPlainText -Force
New-AzADApplication -DisplayName "[enter displayname]" -HomePage "[enter a homepage]" -IdentifierUris "[enter a Identifier url]" -Password $Password -OutVariable app
New-AzADServicePrincipal -ApplicationId $app.ApplicationId
New-AzRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $app.ApplicationId.Guid

Get-AzADApplication -DisplayNameStartWith '[enter name of AD Application from earlier step]' -OutVariable app
Get-AzADServicePrincipal -ServicePrincipalName $app.ApplicationId.Guid -OutVariable SPN
#endregion

#region output info
[ordered]@{
    "clientId"       = "$($app.ApplicationId)"
    "clientSecret"   = "$PlainPassword"
    "subscriptionId" = "$($subscription.subscriptionId)"
    "tenantId"       = "$($subscription.TenantID)"
} | Convertto-json -Compress
#endregion

```
Add the json output as [a secret](https://aka.ms/create-secrets-for-GitHub-workflows) (let's say with the name `AZURE_CREDENTIALS`) in the GitHub repository.