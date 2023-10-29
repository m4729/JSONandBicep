// Parameters = Values that should be able to be adapted easely throughout the template
param location string = resourceGroup().location
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
param appServiceAppName string = 'toylaunch${uniqueString(resourceGroup().id)}'


// The allowed Section will prompt when deploying for either nonprod or prod (Should be used carefully, because can be very limiting)
// the @allowed is the value it will give to the following paremeter environmentType
@allowed( [
  'nonprod'
  'prod'
])
param environmentType string
// Variables are used, when the "same" type of information is being specified multiple times in a bicep file. Here an advanced example with the "Prod" "NonProd" Selection
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

// Creating a Storageaccount
resource storageaccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
     accessTier: 'Hot'
  }
}

//Referencing another file "appService.bicep" which is called app
module app 'appService.bicep' = {
  name: 'app'
  params: {
    appServiceAppName: appServiceAppName
    environmentType: environmentType
    location: location
  }
}



// NOTE: appServiceApp.properties.defaultHostName The Properties have more values here, because after a deployment azure can reference from (after) the deployment itself
// Here we are referencing the Output from the Module appService.bicep and taking its output

output appServiceAppHostName string = app.outputs.appServiceAppHostName
