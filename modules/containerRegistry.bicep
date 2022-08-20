param containerRegistryName string
param location string = resourceGroup().location
param skuName string
param systemAssignedManagedIdentityEnabled bool = true

resource registry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: containerRegistryName
  location: location
  sku: {
    name: skuName
  }
  properties: {
    
  }
  identity: {
   type: systemAssignedManagedIdentityEnabled ? 'SystemAssigned' : 'None'
  }
}

output containerRegistryName string = registry.name
output containerRegistryResourceId string = registry.id
output containerRegistryManagedIdentityPrincipalId string = registry.identity.principalId
