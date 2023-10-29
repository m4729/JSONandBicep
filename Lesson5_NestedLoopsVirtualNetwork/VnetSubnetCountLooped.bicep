// This Template deploys vnets mentioned in the array below and the amount of subnets can be set in the var

param names array = [
  'srvprod'
  'dmzintern'
  'backup'
]

param location string = 'switzerlandnorth'
var subnetCount = 3

resource virtualNetworks 'Microsoft.Network/virtualNetworks@2023-05-01' = [for (name, i) in names : {
  name: 'vnet-${name}'
  location: location
  properties: {
    addressSpace:{
      addressPrefixes:[
        '10.${i}.0.0/16'
      ]
    }
    subnets: [for j in range(1, subnetCount): {
      name: 'subnet-${j}'
      properties: {
        addressPrefix: '10.${i}.${j}.0/24'
      }
    }]
  }
}]
