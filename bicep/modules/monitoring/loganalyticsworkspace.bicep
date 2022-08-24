param workspaceName string
param location string = resourceGroup().location
@minValue(-1)
@maxValue(730)
param retentionDays int = 120

resource workspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: retentionDays
  }
}

output name string = workspace.name
output id string = workspace.id
output apiVersion string = workspace.apiVersion
