param containerName string
param accountName string
param databaseName string
param partitionKeyPaths array
param indexingPaths array = [ '/*' ]
param excludeIndexPaths array = [ '/_etag/?' ]

var indexPaths = [for path in indexingPaths: {
  path: path
}]

var excludePaths = [for path in excludeIndexPaths: {
  path: path
}]

resource account 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' existing = {
  name: accountName
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-05-15' existing = {
  name: databaseName
  parent: account
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  name: containerName
  parent: database
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
  }
}

output name string = container.name
output id string = container.id
output apiVersion string = container.apiVersion
