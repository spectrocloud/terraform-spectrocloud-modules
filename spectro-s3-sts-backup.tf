locals {
  //bsl_names = toset([for v in var.clusters : v.backup_policy.backup_location])
  bsl_names = toset(flatten([for v in var.clusters : [for vv in v.backup_policy : vv.backup_location]]))

  bsl_map = {
    for k, v in data.spectrocloud_backup_storage_location.this :
    v.name => v.id
  }
}

data "spectrocloud_backup_storage_location" "this" {
  for_each = local.bsl_names

  name = each.value
}

resource "spectrocloud_backup_storage_location" "bsl" {
  for_each = var.bsls

  name        = each.value.name
  is_default  = false
  region      = each.value.region
  bucket_name = each.value.bucket_name
  s3 {
    credential_type = "sts"
    arn             = each.value.arn
    external_id     = each.value.external_id
  }
}