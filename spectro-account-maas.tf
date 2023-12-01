locals {
  maas_clusters_cloud_account_names = toset([for v in local.maas_clusters : v.cloud_account])
  maas_cloud_account_names_data_map = {for v in data.spectrocloud_cloudaccount_maas.this : v.name => v.id}
  maas_cloud_account_names_resource_map = {for v in spectrocloud_cloudaccount_maas.account : v.name => v.id}
  maas_cloud_account_names = merge(local.maas_cloud_account_names_data_map, local.maas_cloud_account_names_resource_map)
}


data "spectrocloud_cloudaccount_maas" "this" {
  // TODO: Add depends on the resource once implemented.
  for_each    = local.maas_clusters_cloud_account_names

  name = each.key
}

resource "spectrocloud_cloudaccount_maas" "account" {
  for_each = { for x in local.maas_accounts : x.name => x }

  name              = each.value.name
  context = try(each.value.context, "project")
  private_cloud_gateway_id = each.value.private_cloud_gateway_id
  maas_api_endpoint = each.value.maas_api_endpoint
  maas_api_key      = each.value.maas_api_key
}

output "debug_maas_accounts" {
  value = local.maas_cloud_account_names
}