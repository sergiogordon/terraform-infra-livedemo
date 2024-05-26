provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "terraform_rg" {
  name     = "terraform-resources-env"
  location = "East US"
}

resource "azurerm_storage_account" "terraform_storage_account" {
  name                     = "terraformresourcebucket"
  resource_group_name      = azurerm_resource_group.terraform_rg.name
  location                 = azurerm_resource_group.terraform_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "test"
    project     = "terraform-demo"
  }
}

resource "azurerm_storage_container" "terraform_container" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.terraform_storage_account.name
  container_access_type = "private"
}

output "storage_account_name" {
  value = azurerm_storage_account.terraform_storage_account.name
}

output "container_name" {
  value = azurerm_storage_container.terraform_container.name
}

output "resource_group_name" {
  value = azurerm_resource_group.terraform_rg.name
}
