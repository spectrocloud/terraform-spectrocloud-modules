resource "spectrocloud_registry_oci" "oci_registry" {
  for_each = var.registries

  name       = each.value.name
  type       = each.value.type
  endpoint   = each.value.endpoint
  is_private = true
  credentials {
    credential_type = each.value.credential_type
    arn             = each.value.arn
    external_id     = each.value.external_id
  }
}