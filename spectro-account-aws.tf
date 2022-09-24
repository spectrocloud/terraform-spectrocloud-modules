locals {
  eks_cloud_account_names = toset([for v in local.eks_clusters : v.cloud_account])
  aws_cloud_account_names_data_map = {for v in data.spectrocloud_cloudaccount_aws.this : v.name => v.id}
  aws_cloud_account_names_resource_map = {for v in spectrocloud_cloudaccount_aws.account : v.name => v.id}
  aws_cloud_account_names = merge(local.aws_cloud_account_names_data_map, local.aws_cloud_account_names_resource_map)
}


data "spectrocloud_cloudaccount_aws" "this" {
  for_each    = local.eks_cloud_account_names

  name = each.key
}

resource "spectrocloud_cloudaccount_aws" "account" {
  for_each = { for x in local.eks_accounts : x.name => x }

  name        = each.value.name
  type        = try(each.value.type, "sts")
  aws_access_key = can(each.value.aws_access_key) ? each.value.aws_access_key : null
  aws_secret_key = can(each.value.aws_secret_key) ? each.value.aws_secret_key : null
  arn         = can(each.value.arn) ? each.value.arn : null
  external_id = can(each.value.external_id) ? each.value.external_id : null
}

output "debug_aws_accounts" {
  value = local.aws_cloud_account_names
}