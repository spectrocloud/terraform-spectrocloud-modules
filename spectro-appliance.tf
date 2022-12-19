locals {
  // cluster appliances
  cluster_appliance_uids = flatten([
    for cluster_key, cluster in local.all_edge_clusters : [
      for node_group_key, node_group in cluster.node_groups : [
        for placement_key, placement in node_group.placements : placement.appliance
  ]]])

  all_appliance_uids = setsubtract(local.cluster_appliance_uids, [""])
}


data "spectrocloud_appliance" "this" {
  depends_on = [spectrocloud_appliance.appliance]
  for_each = local.all_appliance_uids

  name = each.value
}

resource "spectrocloud_appliance" "appliance" {
  for_each = var.appliances

  uid = each.value.id
  tags = can(each.value.name) ? {
    name = each.value.name
  } : {}
  pairing_key = try(each.value.pairing_key, "")
}