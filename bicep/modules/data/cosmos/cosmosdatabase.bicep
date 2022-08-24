param databaseName string
param cosmosAccountName string

resource account 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' existing = {
  name: cosmosAccountName
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-05-15' = {
  name: databaseName
  parent: account
  properties: {
    resource: {
      id: databaseName
    }
  }
}

output name string = database.name
output id string = database.id
output apiVersion string = database.apiVersion
