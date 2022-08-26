param functionAppName string
param appServicePlanId string
param storageAccountName string
param enableSystemAssignedManagedIdentity bool = false
@secure()
param appInsightsConnectionString string
@secure()
param appInsightsInstrumentationKey string
param additionalAppSettings array = []
param location string = resourceGroup().location

var identitySettings = {
  type: 'SystemAssigned'
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName
}

var baseAppSettings = [
  {
    name: 'AzureWebJobsStorage'
    value: storageConnectionString
  }
  {
    name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
    value: storageConnectionString
  }
  {
    name: 'WEBSITE_CONTENTSHARE'
    value: '${uniqueString(functionAppName)}-content'
  }
  {
    name: 'FUNCTIONS_WORKER_RUNTIME'
    value: 'dotnet'
  }
  {
    name: 'FUNCTIONS_EXTENSION_VERSION'
    value: '~4'
  }
  {
    name: 'APPINSIGHTS_CONNECTION_STRING'
    value: appInsightsConnectionString
  }
  {
    name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
    value: appInsightsInstrumentationKey
  }
]

var appSettings = union(baseAppSettings, additionalAppSettings)

var storageConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value};'

resource function 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  identity: enableSystemAssignedManagedIdentity ? identitySettings : any(null)
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      appSettings: appSettings
      minTlsVersion: '1.2'
    }
  }
}

output name string = function.name
output id string = function.id
output apiVersion string = function.apiVersion
output managedIdentityPrincipalId string = enableSystemAssignedManagedIdentity ? function.identity.principalId : any(null)
