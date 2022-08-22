param secretName string
@secure()
param secretValue string
param vaultName string
param enabledDate string = utcNow()
param expirationDate string = dateTimeAdd(utcNow(), 'P10Y')
param enabled bool = true

resource vault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: vaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: secretName
  parent: vault
  properties: {
    attributes: {
      enabled: enabled
      exp: dateTimeToEpoch(expirationDate)
      nbf: dateTimeToEpoch(enabledDate)
    }
    value: secretValue
  }
}

output id string = secret.id
output name string = secret.name
output apiVersion string = secret.apiVersion
