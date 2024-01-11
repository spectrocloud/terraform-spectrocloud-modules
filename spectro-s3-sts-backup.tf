locals {
  bsl_names = toset([for v in var.clusters : try(v.backup_policy.backup_location, "") if length(try(v.backup_policy.backup_location, "")) > 0])

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
    credential_type = each.value.credential_type
    arn             = try(each.value.arn, "")
    external_id     = try(each.value.external_id, "")
    access_key      = try(each.value.access_key, "")
    secret_key      = try(each.value.secret_key, "")
  }
}