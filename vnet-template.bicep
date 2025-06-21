resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'CoreServicesVnet'
  location: 'East US'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.20.0.0/27'
        }
      }
      {
        name: 'DatabaseSubnet'
        properties: {
          addressPrefix: '10.20.20.0/24'
        }
      }
      {
        name: 'SharedServicesSubnet'
        properties: {
          addressPrefix: '10.20.10.0/24'
        }
      }
      {
        name: 'PublicServiceSubnet'
        properties: {
          addressPrefix: '10.20.30.0/24'
        }
      }
    ]
  }
}

resource virtualNetwork2 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'ResearchVnet'
  location: 'Southeast Asia'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.40.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'ResearchSystemSubnet'
        properties: {
          addressPrefix: '10.40.0.0/24'
        }
      }

        
    ]
  }
}

resource virtualNetwork3 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'ManufacturingVnet'
  location: 'West Europe'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.30.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'SensorSubnet1'
        properties: {
          addressPrefix: '10.30.20.0/24'
        }
      }
      {
        name: 'SensorSubnet2'
        properties: {
          addressPrefix: '10.30.21.0/24'
        }
      }
      {
        name: 'SensorSubnet3'
        properties: {
          addressPrefix: '10.30.22.0/24'
        }
      }
      {
        name: 'ManufacturingSystemSubnet'
        properties: {
          addressPrefix: '10.30.10.0/24'
        }
      }
    ]
  }
}

resource coreServicesVm 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: 'coreServicesVm'
  location: 'East US'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    osProfile: {
      computerName: 'coreVm'
      adminUsername: 'azureuser'
      adminPassword: 'P@ssw0rd1234!' // Replace with a secure password or use parameters/secrets
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicCoreServices.id
        }
      ]
    }
  }
}

resource nicCoreServices 'Microsoft.Network/networkInterfaces@2021-08-01' = {
  name: 'nicCoreServices'
  location: 'East US'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetwork.name, 'SharedServicesSubnet')
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource manufacturingVm 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: 'manufacturingVm'
  location: 'West Europe'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    osProfile: {
      computerName: 'manufacturingVm'
      adminUsername: 'azureuser'
      adminPassword: 'P@ssw0rd1234!' // Replace with a secure password or use parameters/secrets
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicManufacturing.id
        }
      ]
    }
  }
}

resource nicManufacturing 'Microsoft.Network/networkInterfaces@2021-08-01' = {
  name: 'nicManufacturing'
  location: 'West Europe'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetwork3.name, 'ManufacturingSystemSubnet')
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

