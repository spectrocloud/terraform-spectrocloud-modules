resource "spectrocloud_registry_oci" "oci_registry" {
  for_each = var.registries

  name  = each.value.name
  type = "ecr"
  endpoint = each.value.endpoint
  is_private = true
  credentials {
    credential_type = "sts"
    arn = each.value.arn
    external_id = each.value.external_id
  }
}