param location string = resourceGroup().location
param vnetName string = 'myVnet'
param subnetName string = 'secureSubnet'
param addressPrefix string = '10.0.0.0/16'
param subnetPrefix string = '10.0.0.0/24' 

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
        }
      }
    ]
  }
}
