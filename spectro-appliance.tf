locals {
  // resource appliances
  resource_appliance_uids = []
  //resource_appliance_uids = [for appliance in resource.spectrocloud_appliance.appliance : appliance.uid => tostring(id) ]

  // cluster appliances
  cluster_appliance_uids = flatten([
    for cluster_key, cluster in var.clusters : [
    for node_group_key, node_group in cluster.node_groups : [
    for placement_key, placement in node_group.placements : placement.appliance
  ]]])

  //all_appliance_uids = setsubtract(setunion(local.resource_appliance_uids, local.cluster_appliance_uids), [""])
}

output "cluster_appliance_uids" {
  value = local.cluster_appliance_uids
}

/*data "spectrocloud_appliance" "this" {
  for_each = local.all_appliance_uids

  name = each.value
}*/

/*resource "spectrocloud_appliance" "appliance" {
  for_each = var.appliances

  uid        = each.value.uid
  labels = {
    "name" = try(each.value.name, "")
  }
}*/