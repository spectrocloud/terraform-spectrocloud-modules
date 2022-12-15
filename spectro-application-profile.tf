
resource "spectrocloud_application_profile" "app_profile" {
  for_each = local.application_profiles_iterable
  name    = each.value.name
  version = each.value.version
  context = each.value.context
  tags    = each.value.tags
  description = each.value.description
  cloud = each.value.cloud
  dynamic "pack" {
    for_each = {for pac in each.value.pack: pac.name => pac.value }
    content {
      name = pack.value.name
      type = try(pack.value.type, "")
      registry_uid = try(local.app_registry_name_to_id_map[pack.value.source_app_tier.registry_name][0], "")
      source_app_tier = try(local.app_source_tier_map[pack.value.source_app_tier.name][0], "")
      values = pack.value.values
      properties = pack.value.properties
      dynamic "manifest" {
        for_each = {for f in pack.value.manifest: f.name => f.value}
        content {
          name = manifest.value.name
          content = manifest.value.content
        }
      }
    }
  }
}
