resource "spectrocloud_cluster_group" "clustergroup" {
  for_each = local.cluster_groups_iterable

  name = each.value.name
  tags = try(each.value.tags, null)
  dynamic "clusters" {
    for_each = {for c in each.value.clusters: c.name => c.value }
    content {
      cluster_uid = try(local.cluster_names_group_map[clusters.value.cluster_name][0], null)
      host_dns = try(clusters.value.host_dns, null)
    }
  }
  config{
    host_endpoint_type = try(each.value.config.host_endpoint_type, null)
    cpu_millicore = try(each.value.config.cpu_millicore, null)
    memory_in_mb = try(each.value.config.memory_in_mb, null)
    storage_in_gb = try(each.value.config.storage_in_gb, null)
    oversubscription_percent = try(each.value.config.oversubscription_percent, null)
    values = try(each.value.config.values, null)
  }
}