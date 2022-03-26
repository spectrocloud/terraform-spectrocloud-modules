locals {
  cloud_account_names = toset([for v in local.eks_clusters : v.cloud_account])

  cloud_account_map = {
    for k, v in data.spectrocloud_cloudaccount_aws.this :
    v.name => v.id
  }
}


data "spectrocloud_cloudaccount_aws" "this" {
  for_each = local.cloud_account_names

  name = each.value
}

resource "spectrocloud_cloudaccount_aws" "account" {
  for_each = var.accounts

  type        = "sts"
  name        = each.value.name
  arn         = each.value.arn
  external_id = each.value.external_id
}