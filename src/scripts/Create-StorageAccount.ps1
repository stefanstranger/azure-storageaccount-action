#
#.SYNOPSIS
#	Creates Storage Account.

#.DESCRIPTION
#	Creates the given Storage Account
#

Param( 
    [string]$ResourceGroupName,
    [string]$StorageAccountName,
    [string]$Location,
    [string]$AccountType,
    [string]$AccessTier
) 

$ErrorActionPreference = "Stop" 

# Get reference to the ARM template
Write-Verbose -Message 'Get template to Storage Account'
$templateFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, "..\.\templates\StorageAccount.json"))


# Create parameters object for ARM template
$parametersARM = @{ }
$parametersARM.Add("storageAccountName", $StorageAccountName)
$parametersARM.Add("location", $Location)
$parametersARM.Add("accountType", $AccountType)
$parametersARM.Add("accessTier", $AccessTier)

# Deploy with ARM
Write-Verbose 'Deploy ARM template'
$DeploymentName

New-AzResourceGroupDeployment -Name ((Get-ChildItem $templateFile).BaseName + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile $TemplateFile `
    -TemplateParameterObject $parametersARM `
    -Force `
    -Verbose `
    -ErrorVariable ErrorMessages `
    -ErrorAction SilentlyContinue

Write-Verbose "Deployed ARM template, checking for errors..." 
if ($ErrorMessages) {
    $wholeError = @(@($ErrorMessages) | ForEach-Object { $_.Exception.Message.TrimEnd("`r`n") })
    throw $wholeError
}