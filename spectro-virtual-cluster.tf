
resource "spectrocloud_virtual_cluster" "virtual_cluster" {
  for_each = local.virtual_clusters_iterable

  name = each.value.name
  tags = try(each.value.tags, [])

  host_cluster_uid = try(local.host_clusters_name_map[each.value.host_cluster_name][0], null)
  cluster_group_uid = try(local.vir_clusters_group_name_map[each.value.cluster_group_name][0], null)
  resources {
    max_cpu = try(each.value.resources.max_cpu, null)
    max_mem_in_mb = try(each.value.resources.max_mem_in_mb, null)
    max_storage_in_gb = try(each.value.resources.max_storage_in_gb, null)
    min_cpu = try(each.value.resources.min_cpu, null)
    min_mem_in_mb = try(each.value.resources.min_mem_in_mb, null)
    min_storage_in_gb = try(each.value.resources.min_storage_in_gb, null)
  }
}
