resource "spectrocloud_cloudaccount_aws" "account" {
  for_each = var.accounts

  type        = "sts"
  name        = each.value.name
  arn         = each.value.arn
  external_id = each.value.external_id
}