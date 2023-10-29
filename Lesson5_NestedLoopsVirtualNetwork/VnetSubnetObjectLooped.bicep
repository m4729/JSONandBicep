param location string = 'switzerlandnorth'

var vnets = [
  {
    name: 'vnet-hub'
    addressPrefix: '10.16.0.0/16'
    subnets: [
      {
        name: 'sub-hub'
        subnetPrefix: '10.16.0.0/24'
      }
      {
        name: 'AzureBastionSubnet'
        subnetPrefix: '10.16.1.0/24'
      }
      {
        name: 'sub-hub2'
        subnetPrefix: '10.16.2.0/24'
      }
    ]
  }
  {
    name: 'vnet-srvprod'
    addressPrefix: '10.32.0.0/16'
    subnets: [
      {
        name: 'sub-srvprod'
        subnetPrefix: '10.32.0.0/24'
      }
    ]
  }
]

resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = [for vnet in vnets: {
  name: vnet.name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet.addressPrefix
      ]
    }
    subnets: [for subnet in vnet.subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.subnetPrefix
      }
    }]
  }
}]

