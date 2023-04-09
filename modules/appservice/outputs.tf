output "service_plan_id" {
  description = "The id of the newly created vNet"
  value       = azurerm_service_plan.app_service_hosting_plan.id
}