
resource "spectrocloud_application" "app_deployment"{
  for_each = local.application_deployment_iterable

  name = each.value.name
  tags = try(each.value.tags,[])
  application_profile_uid = try(local.app_profiles_name_map[each.value.application_name][0], "")
  config  {
    cluster_uid = try(local.clusters_name_map[each.value.config.cluster_name][0], "")
    cluster_context = try(each.value.config.cluster_context, "project")
    cluster_name = try(each.value.config.cluster_name, "")
    cluster_group_uid = try(local.clusters_group_name_map[each.value.config.cluster_group_name][0])
    dynamic "limits" {
      for_each = {for f in each.value.config.limits: f.name => f.value}
      content {
        cpu = limits.value.cpu
        memory = limits.value.memory
        storage = limits.value.storage
      }
    }
  }
}