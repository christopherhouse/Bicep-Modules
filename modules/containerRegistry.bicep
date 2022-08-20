param containerRegistryName string
param location string = resourceGroup().location
@allowed([ 'Basic', 'Standard', 'Premium'])
param skuName string
param systemAssignedManagedIdentityEnabled bool = true
param adminUserEnabled bool = false
param dataEndpointEnabled bool = false

@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string = 'Disabled'
@allowed(['Enabled', 'Disabled'])
param zoneRedundancy string = 'Disabled'

resource registry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: containerRegistryName
  location: location
  sku: {
    name: skuName
  }
  properties: {
    adminUserEnabled: adminUserEnabled
    dataEndpointEnabled: dataEndpointEnabled
    networkRuleSet: {
      defaultAction: 'Allow'
    }
    publicNetworkAccess: publicNetworkAccess
    zoneRedundancy: zoneRedundancy
  }
  identity: {
   type: systemAssignedManagedIdentityEnabled ? 'SystemAssigned' : 'None'
  }
}

output containerRegistryName string = registry.name
output containerRegistryResourceId string = registry.id
output containerRegistryManagedIdentityPrincipalId string = registry.identity.principalId
