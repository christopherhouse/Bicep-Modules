param keyVaultName string
param location string = resourceGroup().location
param tenantId string = subscription().tenantId
param adminUserObjectIds array
param applicationUserObjectIds array

var adminAccessPolicies = [for adminUser in adminUserObjectIds: {
  objectId: adminUser
  tenantId: tenantId
  permissions: {
    certificates: [ 'all' ]
    secrets: [ 'all' ]
    keys: [ 'all' ]
  }
}]

var applicationUserPolicies = [for appUser in applicationUserObjectIds: {
  objectId: appUser
  tenantId: tenantId
  permissions: {
    secrets: [ 'get' ]
  }
}]

var accessPolicies = union(adminAccessPolicies, applicationUserPolicies)

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantId
    accessPolicies: accessPolicies
  }
}

output name string = keyVault.name
output id string = keyVault.id
output apiVersion string = keyVault.apiVersion
