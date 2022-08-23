locals {
  eks_cloud_account_names = toset([for v in local.eks_clusters : v.cloud_account])
}


data "spectrocloud_cloudaccount_aws" "this" {
  for_each = local.eks_cloud_account_names

  name = each.value
}

resource "spectrocloud_cloudaccount_aws" "account" {
  for_each = { for x in local.eks_accounts : x.name => x }

  type        = "sts"
  name        = each.value.name
  arn         = each.value.arn
  external_id = each.value.external_id
}