param cosmosAccountName string
param cosmosDatabaseName string
param cosmosContainerName string
param partitionKeyPaths array

param logAnalyticsWorkspaceName string

param appInsightsName string

param functionAppName string
param functionStorageAccountName string
param functionAppSettings array

param keyVaultName string
param keyVaultAdminPrincipalids array

param location string = resourceGroup().location
param deploymentSuffix string = uniqueString(utcNow())

var appServicePlanName = '${functionAppName}-asp'

module cosmosAccount '../../bicep/modules/data/cosmos/cosmosaccount.bicep' = {
  name: 'cosmosaccount-${deploymentSuffix}'
  params: {
    cosmosAccountName: cosmosAccountName
    enableServerless: true
    location: location
    zoneRedundant: true
  }
}

module cosmosDatabase '../../bicep/modules/data/cosmos/cosmosdatabase.bicep' = {
  name: 'cosmosdatabase-${deploymentSuffix}'
  params: {
    cosmosAccountName: cosmosAccount.outputs.name
    databaseName: cosmosDatabaseName
  }
}

module cosmosContainer '../../bicep/modules/data/cosmos/cosmosserverlesscontainer.bicep' = {
  name: 'cosmoscontainer-${deploymentSuffix}'
  params: {
    accountName: cosmosAccount.outputs.name
    containerName: cosmosContainerName
    databaseName: cosmosDatabase.outputs.name
    partitionKeyPaths: partitionKeyPaths
  }
}

module logAnalytics '../../bicep/modules/monitoring/loganalyticsworkspace.bicep' = {
  name: 'loganalytics-${deploymentSuffix}'
  params: {
    workspaceName: logAnalyticsWorkspaceName
    location: location
  }
}

module appInsights '../../bicep/modules/monitoring/appinsights.bicep' = {
  name: 'appinsights-${deploymentSuffix}'
  params: {
    appInsightsName: appInsightsName
    logAnalyticsWorkspaceName: logAnalytics.outputs.name
    location: location
  }
}

module functionStorage '../../bicep/modules/storageaccount.bicep' = {
  name: 'funcstorage-${deploymentSuffix}'
  params: {
    location: location
    storageAccountName:  functionStorageAccountName
  }
}

module webjobsStorage '../../bicep/modules/storagecontainer.bicep' = {
  name: 'webjobsstore-${deploymentSuffix}'
  params: {
    containerName: 'azure-webjobs-storage'
    storageAccountName: functionStorage.outputs.name
  }
}

module webjobsSecrets '../../bicep/modules/storagecontainer.bicep' = {
  name: 'webjobsecres-${deploymentSuffix}'
  params: {
    containerName: 'azure-webjobs-secrets'
    storageAccountName: functionStorage.outputs.name
  }
}

module appServicePlan '../../bicep/modules/apps/serverless/appserviceplan.bicep' = {
  name: 'appserviceplan-${deploymentSuffix}'
  params: {
    appServicePlanName: appServicePlanName
    location: location
  }
}

module functionApp '../../bicep/modules/apps/serverless/functionapp.bicep' = {
  name: 'functionapp-${deploymentSuffix}'
  params: {
    storageAccountName: functionStorageAccountName
    appInsightsConnectionString: appInsights.outputs.connectionString
    appInsightsInstrumentationKey: appInsights.outputs.instrumentationKey
    functionAppName: functionAppName
    location: location
    enableSystemAssignedManagedIdentity: true
    appServicePlanId: appServicePlan.outputs.id
    additionalAppSettings: functionAppSettings
  }
  dependsOn: [
    appInsights
    webjobsSecrets
    webjobsStorage
  ]
}

module keyVault '../../bicep/modules/keyvault.bicep' = {
  name: 'keyvault-${deploymentSuffix}'
  params: {
    adminUserObjectIds: keyVaultAdminPrincipalids
    keyVaultName: keyVaultName
    applicationUserObjectIds: [ functionApp.outputs.managedIdentityPrincipalId ]
    location: location
  }
}

module cosmosSecret '../../bicep/modules/keyvaultsecret.bicep' = {
  name: 'cosmossecret-${deploymentSuffix}'
  params: {
    vaultName: keyVault.outputs.name
    secretName: 'COSMOS-CONNECTION-STRING'
    secretValue: listConnectionStrings(resourceId('Microsoft.DocumentDB/databaseAccounts', cosmosAccountName), '2020-04-01').connectionStrings[0].connectionString
  }
}

module storageSecret '../../bicep/modules/keyvaultsecret.bicep' = {
  name: 'storagesecret-${deploymentSuffix}'
  params: {
    vaultName: keyVault.outputs.name
    secretName:  'STORAGE-CONNECTION-STRING'
    secretValue: 'DefaultEndpointsProtocol=https;AccountName=${functionStorageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(resourceId('Microsoft.Storage/storageAccounts', functionStorageAccountName), '2021-01-01').keys[0].value}'
  }
}
