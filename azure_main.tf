# Configure the Azure provider with optional features
provider "azurerm" {
  features {}
}

# Generate a random string to use as a suffix
resource "random_string" "random_suffix" {
  length  = 4
  special = false
  upper   = false
}

# Create a resource group to organize resources
resource "azurerm_resource_group" "terraform_rg" {
  name     = "terraform-resources-env-${random_string.random_suffix.result}"
  location = "East US"
}

# Create a storage account within the resource group
resource "azurerm_storage_account" "terraform_storage_account" {
  name                     = "terraformresourcebucket${random_string.random_suffix.result}"
  resource_group_name      = azurerm_resource_group.terraform_rg.name
  location                 = azurerm_resource_group.terraform_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Add tags for organization and identification
  tags = {
    environment = "test"
    project     = "terraform-demo"
  }
}

# Create a container within the storage account
resource "azurerm_storage_container" "terraform_container" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.terraform_storage_account.name
  container_access_type = "private"
}

# Output the name of the storage account
output "storage_account_name" {
  value = azurerm_storage_account.terraform_storage_account.name
}

# Output the name of the storage container
output "container_name" {
  value = azurerm_storage_container.terraform_container.name
}

# Output the name of the resource group
output "resource_group_name" {
  value = azurerm_resource_group.terraform_rg.name
}
