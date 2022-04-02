locals {
  tke_cloud_account_names = toset([for v in local.tke_clusters : v.cloud_account])

  tke_cloud_account_map = {
    for k, v in data.spectrocloud_cloudaccount_tencent.this :
    v.name => v.id
  }
}


data "spectrocloud_cloudaccount_tencent" "this" {
  for_each = local.tke_cloud_account_names

  name = each.value
}

resource "spectrocloud_cloudaccount_tencent" "account" {
  for_each = { for x in local.tke_accounts : x.name => x }

  name               = each.value.name
  tencent_secret_id  = each.value.tencent_secret_id
  tencent_secret_key = each.value.tencent_secret_key
}