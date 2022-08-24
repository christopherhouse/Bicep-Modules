param functionAppName string
param appServicePlanName string = '${functionAppName}-asp'
param storageAccountName string
param location string = resourceGroup().location

resource function 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
}

output name string = function.name
output id string = function.id
output apiVersion string = function.apiVersion
