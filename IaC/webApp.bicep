@description('The base name for resources')
param webappname string = uniqueString(resourceGroup().id)

@description('The web app hosting plan name')
param planname string = 'mydemo-plan'

@description('The location for resources')
param location string = resourceGroup().location

@description('The web site hosting plan')
param sku string = 'S1'

resource plan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: planname
  location: location
  sku: {
    name: sku
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource web 'Microsoft.Web/sites@2020-12-01' = {
  name: webappname
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    httpsOnly: true
    serverFarmId: plan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|5.0'
      netFrameworkVersion: 'v4.0'
    }
  }
}

resource webDevSlot 'Microsoft.Web/sites/slots@2021-01-15' = {
  name: '${web.name}/dev'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    httpsOnly: true
    serverFarmId: plan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|5.0'
      netFrameworkVersion: 'v4.0'
    }
  }
}

output siteUrl string = 'https://${web.properties.defaultHostName}/'
output siteDevUrl string = 'https://${webDevSlot.properties.defaultHostName}/'
