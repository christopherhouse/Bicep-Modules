param appServicePlanName string
@allowed(['Y1'])
param skuName string = 'Y1'
@allowed(['Dynamic'])
param skuTier string = 'Dynamic'
param location string = resourceGroup().location

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
}

output name string = appServicePlan.name
output id string = appServicePlan.id
output apiVersion string = appServicePlan.apiVersion
