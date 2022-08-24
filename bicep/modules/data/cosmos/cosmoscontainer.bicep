param containerName string
param accountName string
param databaseName string
param partitionKeyPaths array = []
param indexingPaths array = [ '/*' ]
param excludeIndexPaths array = [ '/_etag/?' ]
param enableAutoscale bool = false
@minValue(1000)
@maxValue(1000000)
param autoscaleMaxThroughput int = 1000
param enableProvisionedThroughput bool = false
param provisionedThroughputRequestUnits int = 0

var indexPaths = [for path in indexingPaths: {
  path: path
}]

var excludePaths = [for path in excludeIndexPaths: {
  path: path
}]

var autoscaleSettings = {
  maxThroughput: autoscaleMaxThroughput
}

resource account 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' existing = {
  name: accountName
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-05-15' existing = {
  name: databaseName
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  name: containerName
  parent:database
  properties: {
    resource: {
      id: containerName
      partitionKey: {
       paths: partitionKeyPaths
       kind: 'Hash' 
      }
      indexingPolicy: {
        includedPaths: indexPaths
        excludedPaths: excludePaths
      }
    }
    options: {
      autoscaleSettings: enableAutoscale ? autoscaleMaxThroughput : any({})
      throughput: enableProvisionedThroughput ? provisionedThroughputRequestUnits : any(null)
    }
  }
}

output name string = container.name
output id string = container.id
output apiVersion string = container.apiVersion
