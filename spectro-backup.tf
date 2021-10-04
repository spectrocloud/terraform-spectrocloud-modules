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