param containerRegistryName string
param location string = resourceGroup().location
@allowed([ 'Basic', 'Standard', 'Premium'])
param skuName string
param systemAssignedManagedIdentityEnabled bool = true
param adminUserEnabled bool = false
param dataEndpointEnabled bool = false

resource registry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: containerRegistryName
  location: location
  sku: {
    name: skuName
  }
  properties: {
    adminUserEnabled: adminUserEnabled
    dataEndpointEnabled: dataEndpointEnabled
  }
  identity: {
   type: systemAssignedManagedIdentityEnabled ? 'SystemAssigned' : 'None'
  }
}

output name string = registry.name
output id string = registry.id
output managedIdentityPrincipalId string = systemAssignedManagedIdentityEnabled ? registry.identity.principalId : ''
output apiVersion string = registry.apiVersion
