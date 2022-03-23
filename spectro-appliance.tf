locals {
  // resource appliances
  resource_appliance_uids = toset([for v in var.appliances : v.uid])

  // cluster appliances
  cluster_appliance_uids = flatten([
    for v in var.clusters : [
    for k in try(v.node_groups.placements, []) : k.name
  ]])

  all_appliance_uids = setsubtract(setunion(local.resource_appliance_uids, local.cluster_appliance_uids), [""])
}

output "cluster_appliance_uids" {
  value = local.cluster_appliance_uids
}


data "spectrocloud_appliance" "this" {
  for_each = local.all_appliance_uids

  name = each.value
}

/*resource "spectrocloud_appliance" "appliance" {
  for_each = var.appliances

  uid        = each.value.uid
  labels = {
    "name" = try(each.value.name, "")
  }
}*/