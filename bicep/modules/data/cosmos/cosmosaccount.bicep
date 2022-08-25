param cosmosAccountName string
param location string = resourceGroup().location
param zoneRedundant bool = true
param enableServerless bool = false

var capabilities = [
  {
    name: 'EnableServerless'
  }
]

resource account 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' = {
  name: cosmosAccountName
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        isZoneRedundant: zoneRedundant
        failoverPriority: 0
      }
    ]
    capabilities: enableServerless ? capabilities : []
  }
}

output name string = account.name
output id string = account.id
output apiVersion string = account.apiVersion
output connectionString string = account.listConnectionStrings(account.apiVersion)[0].connectionString
