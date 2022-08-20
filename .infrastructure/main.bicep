param registryName string
param location string = resourceGroup().location
param deploymentSuffix string = '-${uniqueString(utcNow())}'

module registry '../modules/containerRegistry.bicep' = {
  name: 'registry-${deploymentSuffix}'
  params: {
    containerRegistryName: registryName
    location: location
    skuName: 'Basic'
  }
}
