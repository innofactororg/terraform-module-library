resource "azurerm_sentinel_automation_rule" "automation_rule" {
  name                       = var.name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  display_name               = var.display_name
  order                      = var.order
  enabled                    = var.enabled
  expiration                 = var.expiration

  dynamic "action_incident" {
    for_each = try(var.modify_properties== null ? [] : var.modify_properties)
    content {
      order                  = try(action_incident.value.order, null)
      status                 = try(action_incident.value.action_incident.status, null)
      classification         = try(action_incident.value.classification, null)
      classification_comment = try(action_incident.value.classificationComment, null)
      labels                 = try(action_incident.value.labels, null)
      owner_id               = try(action_incident.value.owner, null)
      severity               = try(action_incident.value.severity, null)
    }
  }

  dynamic "action_playbook" {
    for_each = var.run_playbook == null ? [] : var.run_playbook
    content {
      logic_app_id   = try(var.combined_objects_logic_app_workflow[try(action_playbook.value.lz_key, var.client_config.landingzone_key)][action_playbook.value.logic_app_key].id, action_playbook.value.logicAppResourceId, null)
      order          = try(action_playbook.value.order, null)
      tenant_id      = try(action_playbook.value.tenantId, null)
    }
  }

  dynamic "condition" {
    for_each = var.condition_type == null ? [] : var.condition_type

    content {
      operator = try(condition.value.conditionProperties.operator, null)
      property = try(condition.value.conditionProperties.propertyName, null)
      values   = try(condition.value.conditionProperties.propertyValues, null)
    }
  }
}
