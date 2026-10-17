resource "azurerm_resource_group" "lab_rg" {
  name     = "NodeJs-Terraform-RG"
  location = "West Europe"
}

resource "azurerm_service_plan" "lab_plan" {
  name                = "sp-terraform-demo"
  resource_group_name = azurerm_resource_group.lab_rg.name
  location            = azurerm_resource_group.lab_rg.location
  os_type             = "Linux"
  sku_name            = "F1" # Free tier
}

resource "azurerm_linux_web_app" "lab_app" {
  name                = "app-terraform-demo-${random_integer.suffix.result}"
  resource_group_name = azurerm_resource_group.lab_rg.name
  location            = azurerm_service_plan.lab_plan.location
  service_plan_id     = azurerm_service_plan.lab_plan.id

  site_config {
    always_on = false
  }

  app_settings = {
    "WEBSITES_PORT" = "80"
  }
}

resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}
