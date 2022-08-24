param cosmosAccountName string
param cosmosDatabaseName string
param cosmosContainerName string
param partitionKeyPaths array


param location string = resourceGroup().location
param deploymentSuffix string = uniqueString(utcNow())

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
