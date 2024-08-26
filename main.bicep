@description('Location for all the resources.')
param location string = resourceGroup().location

@description('Admin Login Username')
param adminLogin string 

param kvResourceGroup string
param kvName string

@description('Name prefix for all the resources.')
var resourcePrefix = replace(resourceGroup().name, 'rg', '')


// VNet Module
module vnet './vnet.bicep' = {
  name: 'VNet_Deploy'
  params: {
    location: location
  }
  scope: resourceGroup()
}

// Key Vault Resource
resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: kvName
  scope: resourceGroup(subscription().subscriptionId, kvResourceGroup )
}

// AKS Module
module aksCluster './aks.bicep' = {
  name: 'aksModule'
  params:{
    clusterName: 'StudiCluster'
    location: location
  }
}
// SQL Server Module
module sql_Server './sqlServer.bicep' = {
  name: 'SQL_Server_Deploy'
  params: {
    sqlServerName: '${resourcePrefix}sql'
    adminLogin: adminLogin
    adminPassword: kv.getSecret('dbpassword')
    databaseName: '${resourcePrefix}db'
    serverLocation: location
    privateEndpointName: '${resourcePrefix}sqlpe'
  }
}
