data "azurerm_management_group" "mg" {
  name = var.settings.management_group_id
}

resource "azurerm_management_group_subscription_association" "subscription_association" {
  count = try(var.settings.management_group_id, null) == null ? 0 : 1

  management_group_id = data.azurerm_management_group.mg.id
  subscription_id     = "/subscriptions/${try(azurerm_subscription.sub.0.subscription_id, var.settings.subscription_id)}"
}

# resource "null_resource" "mg" {
#   depends_on = [null_resource.refresh_access_token]

#   count = try(var.settings.management_group_id, null) == null ? 0 : 1

#   triggers = {
#     subscription_id = try(azurerm_subscription.sub.0.subscription_id, var.settings.subscription_id)
#     mg_id           = var.settings.management_group_id
#   }

#   provisioner "local-exec" {
#     command     = format("%s/scripts/assign_subscription_to_mg.sh", path.module)
#     interpreter = ["/bin/bash"]
#     on_failure  = fail

#     environment = {
#       METHOD          = "PUT"
#       SUBSCRIPTION_ID = self.triggers.subscription_id
#       MG_ID           = self.triggers.mg_id
#     }
#   }

#   provisioner "local-exec" {
#     command     = format("%s/scripts/assign_subscription_to_mg.sh", path.module)
#     when        = destroy
#     interpreter = ["/bin/bash"]
#     on_failure  = continue

#     environment = {
#       METHOD          = "DELETE"
#       SUBSCRIPTION_ID = self.triggers.subscription_id
#       MG_ID           = self.triggers.mg_id
#     }
#   }

# }
