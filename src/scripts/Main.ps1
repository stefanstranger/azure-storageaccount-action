<#
    Script that retrieves input from Github Actions input
#>

Param( 
    [string]$Action,
    [string]$ServiceConnection = "SERVICECONNECTION",
    [string]$ResourceGroupName,
    [string]$StorageAccountName,
    [string]$Location,
    [string]$AccountType,
    [string]$AccessTier
) 

#region Verbose Output for input fields
Write-Output -InputObject ('Input fields are:')
Write-Output -InputObject ('Action: {0}' -f $Action)
Write-Output -InputObject ('StorageAccountName:  {0}' -f $StorageAccountName)
Write-Output -InputObject ('ResourceGroupName: {0}' -f $resourceGroupName)
Write-Output -InputObject ('ServiceConnection: {0}' -f $ServiceConnection)
#endregion

#region retrieve ServiceConnection Secret via Environment Variable
Write-Output -InputObject ('Retrieving Environment variable info')
$Credential = [Environment]::GetEnvironmentVariable($ServiceConnection) | ConvertFrom-Json
Write-Output ('Credential clientid info {0}:' -f $($Credential.clientid))
#endregion

#region authenticate with Azure Subscription
$azureAppId = $($Credential.clientid)
$azureAppSecret = ConvertTo-SecureString $($Credential.clientSecret) -AsPlainText -Force
$azureAppCred = (New-Object System.Management.Automation.PSCredential $azureAppId, $azureAppSecret )
$subscriptionId = $($Credential.subscriptionId)
$tenantId = $($Credential.tenantId)
Connect-AzAccount -ServicePrincipal -SubscriptionId $subscriptionId -TenantId $tenantId -Credential $azureAppCred
#endregion

#region Execute selected Action
switch ($action) {
    "createStorageAccount" {
        Write-Output -InputObject 'Create Storage Account'
        Write-Output -InputObject ('Location: { 0 }' -f $Location)
        Write-Output -InputObject ('AccountType: { 0 }' -f $AccountType)
        Write-Output -InputObject ('AccessTier: { 0 }' -f $AccessTier)
        #region deploy Storage Account
        $params = @{
            'StorageAccountName' = $StorageAccountName
            'ResourceGroupName'  = $ResourceGroupName
            'Location'           = $Location
            'AccountType'        = $AccountType
            'AccessTier'         = $AccessTier
        }
        \tmp\scripts\Create-StorageAccount.ps1 @params
        #endregion
    }
    "removeStorageAccount" {
        Write-Output -InputObject 'Remove Storage Account'
        Write-Output -InputObject ('Storage Account Name: { 0 }' -f $StorageAccountName)
        Write-Output -InputObject ('Resourece Group Name: { 0 }' -f $ResourceGroupName)
        #region Remove Storage Account
        $params = @{
            'StorageAccountName' = $StorageAccountName
            'ResourceGroupName'  = $ResourceGroupName
        }
        \tmp\scripts\Remove-StorageAccount.ps1 @params
        #endregion
    }
    default {
        throw 'Unknow action'
    }
}



