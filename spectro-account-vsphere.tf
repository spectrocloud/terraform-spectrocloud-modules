locals {
  vsphere_cloud_account_names = toset([for v in local.vsphere_clusters : v.cloud_account])
}


data "spectrocloud_cloudaccount_vsphere" "this" {
  // TODO: Add depends on the resource once implemented.
  for_each = local.vsphere_cloud_account_names

  name = each.value
}

/*resource "spectrocloud_cloudaccount_vsphere" "account" {
  for_each = { for x in local.vsphere_accounts : x.name => x }

  name        = each.value.name
  private_cloud_gateway_id = each.value.private_cloud_gateway_id
  vsphere_vcenter         = each.value.vsphere_vcenter
  vsphere_username = each.value.vsphere_username
  vsphere_password = each.value.vsphere_password
  vsphere_ignore_insecure_error = each.value.vsphere_ignore_insecure_error
}*/