locals {
  // cluster appliances
  cluster_appliance_uids = flatten([
    for cluster_key, cluster in local.all_edge_clusters : [
    for node_group_key, node_group in cluster.node_groups : [
    for placement_key, placement in node_group.placements : placement.appliance
  ]]])

  all_appliance_uids = setsubtract(local.cluster_appliance_uids, [""])
}

output "cluster_appliance_uids" {
  value = local.all_appliance_uids
}

data "spectrocloud_appliance" "this" {
  for_each = local.all_appliance_uids

  name = each.value
}

resource "spectrocloud_appliance" "appliance" {
  for_each = var.appliances

  uid        = each.value.uid
  labels = {
    "name" = try(each.value.name, "")
  }
}