param location string = resourceGroup().location

@description('The name of the Managed Cluster resource.')
param clusterName string 

resource aks 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: '1.29.7'
    dnsPrefix: 'dnsprefix'
    enableRBAC: true
    agentPoolProfiles: [
      {
        name: 'systempool'
        count: 1
        enableAutoScaling: true
        minCount: 1
        maxCount: 3
        vmSize: 'Standard_B2s'
        osType: 'Linux'
        mode: 'System'
      }
    ]
  }
}
