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
@allowed(['functionapp'])
param appServicePlanKind string = 'functionapp'
param location string = resourceGroup().location
param zoneRedundant bool = false

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  kind: appServicePlanKind
  sku: {
    name: skuName
    tier: skuTier
    size: skuSize
    family: skuFamily
    capacity: skuCapacity
  }
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: zoneRedundant
  }
}

output name string = appServicePlan.name
output id string = appServicePlan.id
output apiVersion string = appServicePlan.apiVersion
