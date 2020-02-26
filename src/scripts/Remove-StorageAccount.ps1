#
#.SYNOPSIS
#	Removes Storage Account.

#.DESCRIPTION
#	Removes the given Storage Account Resource

#.OUTPUTS
#	Progress messages
#*/

Param( 
    [string]$resourceGroupName,
    [string]$StorageAccountName
) 

$ErrorActionPreference = "Stop" 

# Check if the Storage Account exists
$StorageAccountToBeRemoved = Get-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $resourceGroupName -ErrorAction SilentlyContinue

if (!($StorageAccountToBeRemoved)) {
    Write-Output -InputObject ('Storage Account {0} is already removed.' -f $StorageAccountName)
}
else {
    Remove-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $resourceGroupName -Force
    Write-Output -InputObject ('Storage Account {0} is removed.' -f $StorageAccountName)
}