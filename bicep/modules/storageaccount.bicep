param storageAccountName string
param location string
@allowed(['Standard_LRS', 'Standared_ZRS', 'Standard_GRS', 'Standard_RAGRS'])
param skuName string = 'Standard_LRS'
@allowed(['Cool', 'Hot'])
param storageAccessTier string = 'Hot'

resource storage 'Microsoft.Storage/storageAccounts@2021-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: storageAccessTier
  }
}

output id string = storage.id
output name string = storage.name
output apiVersion string = storage.apiVersion
