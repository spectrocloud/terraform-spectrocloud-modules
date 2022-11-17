locals {
  alerts = toset(flatten([
  for i, v in var.alerts: {
    name = format("%s-%s", i, v.project)#try(v.alerts[0].type,"http")
    value = {
      is_active = try(v.is_active, true)
      component = try(v.component, "ClusterHealth")
      project = try(v.project, "Default")
      email = try(v.email, [])
      http = try(tolist(
        [
          for index,hook in v.http:{
          name = format("%s-%s", tostring(index), hook.method)
          value = {
            method = hook.method
            url=hook.url
            body = hook.body
            headers= hook.headers
          }
        }
        ]
      ), [])
    }
  }]))

  alert_iterable = { for alert in local.alerts: alert.name => alert.value }
}


resource "spectrocloud_alert" "cluster_health_alerts" {
  for_each = local.alert_iterable

  project = each.value.project
  is_active = each.value.is_active
  component = each.value.component

  dynamic "http" {
    for_each = { for http_alert in each.value.http: http_alert.name => http_alert.value }
    content {
      method = http.value.method
      url = http.value.url
      body = http.value.body
      headers = http.value.headers
    }
  }
  dynamic "email" {
    for_each = length(try(each.value.email,[])) > 0 ? [1] : []
    content {
      alert_all_users = try(each.value.email.alert_all_users, false)
      identifiers = try(each.value.email.identifiers, [])
    }
  }
}
