param location string
param appServiceAppName string 

// The allowed Section will prompt when deploying for either nonprod or prod (Should be used carefully, because can be very limiting)
@allowed( [
  'nonprod'
  'prod'
])
param environmentType string

// Variables are used, when the "same" type of information is being specified multiple times in a bicep file. Here an advanced example with the "Prod" "NonProd" Selection
var appServicePlanName = 'toy-product-plan-starter0947'
var appServicePlanSkuName= (environmentType == 'prod') ? 'P2v3' : 'F1'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
   sku: {
    name: appServicePlanSkuName
   }
}

resource appServiceApp 'Microsoft.Web/sites@2022-09-01' = {
  name: appServiceAppName
  location: location
   properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
   }
}


// NOTE: appServiceApp.properties.defaultHostName The Properties have more values here, because after a deployment azure can reference from (after) the deployment itself
output appServiceAppHostName string = appServiceApp.properties.defaultHostName
