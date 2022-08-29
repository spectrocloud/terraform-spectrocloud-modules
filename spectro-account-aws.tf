locals {
  eks_cloud_account_names = toset([for v in local.eks_clusters : v.cloud_account])
}


data "spectrocloud_cloudaccount_aws" "this" {
  for_each = local.eks_cloud_account_names

  name = each.value
}

resource "spectrocloud_cloudaccount_aws" "account" {
  for_each = { for x in local.eks_accounts : x.name => x }

  name        = each.value.name
  type        = try(each.value.type, "sts")
  aws_access_key = try(each.value.aws_access_key, nil)
  aws_secret_key = try(each.value.aws_secret_key, nil)
  arn         = try(each.value.arn, nil)
  external_id = try(each.value.external_id, nil)
}