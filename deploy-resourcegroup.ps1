
Param(
    [string] [parameter(Mandatory = $true)] $ResourceGroupName,
    [string] [parameter(Mandatory = $true)] $TemplateFile,
    [string] [parameter(Mandatory = $true)] $TemplateParametersFile
)


$OptionalParameters = New-Object -TypeName Hashtable

#Assuming staging slot exists - else just Get-AzWebApp should suffice for services without a staging slot.
$prodSlotExists = Get-AzWebAppSlot 'staging' -name 'KMD-example-prod-slot-deploy-with-staging' -resourceGroupName $ResourceGroupName -ErrorAction:SilentlyContinue -ErrorVariable stagingslotNotFound

If ($stagingslotNotFound) {
    $OptionalParameters['shouldDeployProdSlot'] = "true"
}

Write-Host 'shouldDeployProdSlot: ' $OptionalParameters['shouldDeployProdSlot']

New-AzResourceGroup -Name $ResourceGroupName -Location "West Europe"  -Verbose -Force 

New-AzResourceGroupDeployment -Name ((Get-ChildItem $TemplateFile).BaseName + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
    -ResourceGroupName $ResourceGroupName `
    -Force `
    -TemplateFile $TemplateFile `
    -TemplateParameterFile $TemplateParametersFile `
    @OptionalParameters `
    -Verbose `
    -ErrorVariable ErrorMessages
