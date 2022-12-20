locals{
  # Collection of multiple yaml with app_profile
  all_app_profiles = flatten([for app in var.application_profiles:  app if can(app)])

  # All packs inside app_profile
  app_packs = flatten([for app in local.all_app_profiles : [for pac in app.pack : pac if can(pac.name)]])

  # Get registry name's used across all packs
  all_app_registries = [for v in local.app_packs : try(v.source_app_tier.registry_name, "")]

  # Get source tier information's used across all packs
  all_source_app_tier = [ for p in local.app_packs : try(
    {
      type: try(p.type, "")
      name: try(p.source_app_tier.name, "")
      version: try(p.source_app_tier.version, "")
      registry_uid: try(local.app_registry_name_to_id_map[p.source_app_tier.registry_name][0], "")
    }, {})]

  # Stored registry UID as value with name as key in map
  app_registry_name_to_id_map = {
  for k, v in data.spectrocloud_registry.app_registries :
  v.name => v.id... if v.name != null
  }

  # Stored source_tier_UID as value with source tier name as key in map
  app_source_tier_map = {
  for k, v in data.spectrocloud_pack_simple.app_source_tiers:
  v.name => v.id... if v.name != null
  }

  application_profiles = [for v in local.all_app_profiles : {
    name  = format("%s%%%s", v.name, v.context)
    value = {
      name    = v.name
      version = v.version
      context = v.context
      tags    = try(v.tags, [])
      description = try(v.description, "")
      cloud = try(v.cloud, "all")
      pack = try(tolist(
        [
        for index,pack in v.pack:{
          name = format("%s%%%s",pack.name, tostring(index))
          value = {
            name = pack.name
            type = pack.type
            source_app_tier = try(pack.source_app_tier, {} )
            values = try(pack.values, "")
            manifest = try(tolist([
            for i,mf in pack.manifest:{
              name = format("%s%%%s",mf.name, tostring(i))
              value = {
                name = pack.manifest[i].name
                content = pack.manifest[i].content
              }
            }]),[])
            properties = try(pack.properties, {})
          }
        }]))
    } } ]
  application_profiles_iterable = { for app in toset(local.application_profiles): app.name => app.value }

}

data "spectrocloud_registry" "app_registries" {
  count = length(local.all_app_registries)
  name = local.all_app_registries[count.index]
}

data "spectrocloud_pack_simple" "app_source_tiers" {
  count = length(local.all_source_app_tier)
  name = local.all_source_app_tier[count.index].name
  type = local.all_source_app_tier[count.index].type
  version = local.all_source_app_tier[count.index].version
  registry_uid = local.all_source_app_tier[count.index].registry_uid
}
