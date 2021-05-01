resource "azurerm_resource_group" "rg" {
  name = var.rg_name
  location = var.location
}


resource "azurerm_app_service_plan" "plan" {
  name = var.app_svc_plan
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_application_insights" "appi" {
  name = var.ai_name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  application_type = var.ai_type
}

resource "azurerm_app_service" "website" {
  name = var.web_app_name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  app_service_plan_id = azurerm_app_service_plan.plan.id
  client_affinity_enabled = false

  site_config {
    always_on = true
    default_documents = [ "hostingstart.html" ]
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "12.x"
  }
}