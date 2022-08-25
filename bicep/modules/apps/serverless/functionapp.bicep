param functionAppName string
param appServicePlanName string
param storageAccountName string
param enableSystemAssignedManagedIdentity bool = false
@secure()
param appInsightsConnectionString string
@secure()
param appInsightsInstrumentationKey string
param location string = resourceGroup().location

var identitySettings = {
  type: 'SystemAssigned'
}

resource appServicePlan 'Microsoft.Web/sites@2022-03-01' existing = {
  name: appServicePlanName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName
}

var storageConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value};'

resource function 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  identity: enableSystemAssignedManagedIdentity ? identitySettings : any(null)
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
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
      minTlsVersion: '1.2'
    }
  }
}

output name string = function.name
output id string = function.id
output apiVersion string = function.apiVersion
output managedIdentityPrincipalId string = enableSystemAssignedManagedIdentity ? function.identity.principalId : any(null)
