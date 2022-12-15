locals{
  # Collection of multiple yaml with app_profile
  all_app_profiles = flatten([for files in var.application_profiles: [for app in files.app_profile : app]])

  # All packs inside app_profile
  app_packs = flatten([for app in local.all_app_profiles : [for pac in app.pack : pac if can(pac.name)]])

  # Get registry name's used across all packs
  all_registries = [for v in local.app_packs : try(v.source_app_tier.registry_name, "")]

  # Get source tier information's used across all packs
  all_source_app_tier = [ for p in local.app_packs : try(
    {
      type: try(p.type, "")
      name: try(p.source_app_tier.name, "")
      version: try(p.source_app_tier.version, "")
      registry_uid: try(local.registry_key_map[p.source_app_tier.registry_name][0], "")
    }, {})]

  # Stored registry UID as value with name as key in map
  registry_key_map = {
  for k, v in data.spectrocloud_registry.registries :
  v.name => v.id... if v.name != null
  }

  # Stored source_tier_UID as value with source tier name as key in map
  source_tier_map = {
  for k, v in data.spectrocloud_pack_simple.source_tiers:
  v.name => v.id... if v.name != null
  }
}

data "spectrocloud_registry" "registries" {
  count = length(local.all_registries)
  name = local.all_registries[count.index]
}

data "spectrocloud_pack_simple" "source_tiers" {
  count = length(local.all_source_app_tier)
  name = local.all_source_app_tier[count.index].name
  type = local.all_source_app_tier[count.index].type
  version = local.all_source_app_tier[count.index].version
  registry_uid = local.all_source_app_tier[count.index].registry_uid
}
