param prefix string = 'mfappfile'

param location string = resourceGroup().location

var storageAccountName = '${prefix}${uniqueString(resourceGroup().id)}'
var mountPath = '/mounts/appservice'


resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource fileservices 'Microsoft.Storage/storageAccounts/fileServices@2021-09-01' = {
  name: 'default'
  parent: storageAccount
  sku: {
    name : 'Standard_RAGRS'
    tier : 'Standard'
  }
}

resource fileshare 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-09-01' = {
  name: 'appserviceshare'
  parent: fileservices
  properties: {
    quota: 5120
    accessTier : 'TransactionOptimized'
  }
}

resource serverFarm 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: '${prefix}appplan'
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
  kind: 'app'
}

resource webApplication 'Microsoft.Web/sites@2021-03-01' = {
  name: '${prefix}api'
  location: location
  properties: {
    serverFarmId: serverFarm.id
    siteConfig: {
      appSettings: [
        {
          name: 'MountPath'
          value: '../../..${mountPath}'
        }
      ]
      azureStorageAccounts: {
        blobmount : {
          type: 'AzureFiles'
          accountName: storageAccount.name
          shareName: fileshare.name
          mountPath: mountPath
          accessKey: storageAccount.listKeys().keys[0].value
        }
      }
    }
    
  }
  kind: 'app'
}

