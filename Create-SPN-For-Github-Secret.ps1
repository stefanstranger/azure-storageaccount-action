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
$PlainPassword = "P@ssW0rD!123456789"
$Password = ConvertTo-SecureString $PlainPassword  -AsPlainText -Force
New-AzADApplication -DisplayName "demogithubaction" -HomePage "https://www.stranger.nl/demo" -IdentifierUris "https://www.stranger.nl/demo" -Password $Password -OutVariable app
New-AzADServicePrincipal -ApplicationId $app.ApplicationId
New-AzRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $app.ApplicationId.Guid

Get-AzADApplication -DisplayNameStartWith 'demogithubaction' -OutVariable app
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
