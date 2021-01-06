# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tstate"
    storage_account_name = "tstate2711"
    container_name       = "tstate"
    key                  = ".terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Create resource group
resource "azurerm_resource_group" "myRG" {
  name     = "myTFResourceGroup"
  location = var.location

  tags = {
        Environment = "Terraform Getting Started"
        Team = "DevOps"
    }
}

# Create a virtual network
resource "azurerm_virtual_network" "myVNET" {
    name                = "myTFVnet"
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.myRG.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "myTFSubnet"
  resource_group_name  = azurerm_resource_group.myRG.name
  virtual_network_name = azurerm_virtual_network.myVNET.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "myTFPublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.myRG.name
  allocation_method   = "Static"
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "myTFNSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.myRG.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                      = "myNIC"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.myRG.name

  ip_configuration {
    name                          = "myNICConfg"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}