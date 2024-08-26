param sqlServerName string
param adminLogin string
@secure()
param adminPassword string
param databaseName string
param serverLocation string
param privateEndpointName string
param subnetName string = 'secureSubnet' // Replace with your subnet name
param virtualNetworkName string = 'myVnet' // Replace with your vNet name

// SQL Server Resource
resource SQL_Server 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: sqlServerName
  location: serverLocation
  properties: {
    administratorLogin: adminLogin
    administratorLoginPassword: adminPassword
  }
}

// Database on SQL Server Resource
resource Database 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  name: databaseName
  parent: SQL_Server
  location: serverLocation
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

// Firewall
resource DB_Firewall 'Microsoft.Sql/servers/firewallRules@2023-05-01-preview' = {
  name: 'Database server firewall'
  parent: SQL_Server
  properties: {
    startIpAddress: '10.0.0.0'
    endIpAddress: '10.0.0.254'
  }
}

// Private Endpoint Resource
resource Private_Endpoint 'Microsoft.Network/privateEndpoints@2023-11-01' = {
  name: privateEndpointName
  location: serverLocation
  properties: {
    subnet: {
      id: resourceId('Microsoft.Network/VirtualNetworks/subnets', virtualNetworkName, subnetName)
    }
    privateLinkServiceConnections: [
      {
        name: 'sqlServerConnection'
        properties: {
          privateLinkServiceConnectionState: {
            status: 'Approved'
          }
          privateLinkServiceId: SQL_Server.id
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }
}

// Outputs
output sqlServer_name string = SQL_Server.name
output database_name string = Database.name
output privateEndpoint_name string = Private_Endpoint.name
