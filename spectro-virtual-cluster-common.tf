locals{
  vir_clusters = flatten([for config in var.virtual_clusters:  config if can(config)])
  host_clusters_name = flatten([for cluster in local.vir_clusters: cluster.host_cluster_name if can(cluster.host_cluster_name)])
  vir_cluster_groups_name = flatten([for cluster in local.vir_clusters: cluster.cluster_group_name if can(cluster.cluster_group_name)])

  vir_clusters_group_name_map = {
  for k, v in data.spectrocloud_cluster_group.vir_cluster_group :
  v.name => v.id... if v.name != null
  }

  host_clusters_name_map = {
  for k, v in data.spectrocloud_cluster.host_cluster :
  v.name => v.id... if v.name != null
  }

  virtual_clusters = try([for c in local.vir_clusters: {
    name = format("%s",c.name)
    value = {
      name = c.name
      host_cluster_name = try(c.host_cluster_name, null)
      cluster_group_name =  try(c.cluster_group_name, null)
      resources = try({
        max_cpu = try(c.resources.max_cpu, null)
        max_mem_in_mb = try(c.resources.max_mem_in_mb, null)
        max_storage_in_gb = try(c.resources.max_storage_in_gb, null)
        min_cpu = try(c.resources.min_cpu, null)
        min_mem_in_mb = try(c.resources.min_mem_in_mb, null)
        min_storage_in_gb = try(c.resources.min_storage_in_gb, null)
      })
    }
  }], [])

  virtual_clusters_iterable = { for v in toset(local.virtual_clusters): v.name => v.value }

}

data "spectrocloud_cluster" "host_cluster"{
  count = length(local.host_clusters_name)
  name = local.host_clusters_name[count.index]
}

data "spectrocloud_cluster_group" "vir_cluster_group" {
  count = length(local.vir_cluster_groups_name)
  name = local.vir_cluster_groups_name[count.index]
}
