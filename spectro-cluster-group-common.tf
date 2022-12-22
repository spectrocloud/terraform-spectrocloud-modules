locals {
  cluster_group_collection = flatten([for cg in var.cluster_groups: cg if can(cg)])
  clusters_names = flatten([for c in local.cluster_group_collection: [for cluster in c.clusters: cluster.cluster_name if can(cluster.cluster_name)]])

  cluster_names_group_map = {
    for k, v in data.spectrocloud_cluster.cluster_gps :
      v.name => v.id... if v.name != null
  }

  cluster_groups = try([for c in local.cluster_group_collection:{
    name = format("%s", c.name)
    value = {
      name = c.name
      tags = try(c.tags, null)
      clusters = try(tolist([for n in c.clusters:{
        name = n.cluster_name
        value = {
          cluster_name = try(n.cluster_name, null)
          host_dns = try(n.host_dns, null)
        }
      }]), [])
      config = {
        host_endpoint_type = try(c.config.host_endpoint_type, null)
        cpu_millicore = try(c.config.cpu_millicore, null)
        memory_in_mb = try(c.config.memory_in_mb, null)
        storage_in_gb =  try(c.config.storage_in_gb, null)
        oversubscription_percent = try(c.config.oversubscription_percent, null)
        values = try(c.config.values, null)
      }
    }
  }], [])

  cluster_groups_iterable = { for cg in toset(local.cluster_groups): cg.name => cg.value }
}

data "spectrocloud_cluster" "cluster_gps"{
  count = length(local.clusters_names)
  name = local.clusters_names[count.index]
  context = "tenant"
}