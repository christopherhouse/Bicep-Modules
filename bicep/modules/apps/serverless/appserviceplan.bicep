param appServicePlanName string
@allowed(['Y1'])
param skuName string = 'Y1'
@allowed(['Dynamic'])
param skuTier string = 'Dynamic'
@allowed(['Y1'])
param skuSize string = 'Y1'
@allowed(['Y'])
param skuFamily string = 'Y'
param skuCapacity int = 0
param location string = resourceGroup().location

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    tier: skuTier
    size: skuSize
    family: skuFamily
    capacity: skuCapacity
  }
}

output name string = appServicePlan.name
output id string = appServicePlan.id
output apiVersion string = appServicePlan.apiVersion
