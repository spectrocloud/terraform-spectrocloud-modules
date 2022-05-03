locals {
  infra_profile_names = [for v in var.clusters : format("%s%%%s", v.profiles.infra.name, coalesce(v.profiles.infra.version, "1.0.0"))]

  system_profile_names = flatten([
    for v in var.clusters : [
      for k in try(v.profiles.system, []) : format("%s%%%s", k.name, coalesce(k.version, "1.0.0"))
  ]])

  addon_profile_names = flatten([
    for v in var.clusters : "${[
      for k in try(v.profiles.addons, []) :
        k.version ?
            format("%s%%%s", k.name, k.version) :
            format("%s%%%s", k.name, "1.0.0")
      ]
    }"
  ])

  profile_names = toset(concat(concat(local.infra_profile_names, local.addon_profile_names), local.system_profile_names))

  profile_map = { //profiles is map of profile name and complete cluster profile object
    for x in flatten([
      for k, p in data.spectrocloud_cluster_profile.this : { name = format("%s%%%s", p.name, coalesce(p.version, "1.0.0")), profile = p }
    ]) :
    x.name => x.profile
  }

  cluster-profile-pack-map = {
    for x in flatten([
      for k, v in data.spectrocloud_cluster_profile.this : [
        for p in v.pack : { name = format("%s%%%s-%s", v.name, coalesce(v.version, "1.0.0"), p.name), pack = p }
    ]]) :
    x.name => x.pack
  }

  cluster_infra_profiles_map = {
    for v in var.clusters :
    v.name => v.profiles.infra
  }

  cluster_addon_profiles_map = {
    for v in var.clusters :
    v.name => try(v.profiles.addons, [])
  }

  cluster_profile_pack_manifests = { for v in flatten([
    for v in var.profiles : [
      for p in v.packs : {
        name  = format("%s-%s", v.name, p.name)
        value = try(p.manifests, [])
      }
    ]
    ]) : v.name => v.value...
  }

  packs           = flatten([for v in var.profiles : [for vv in v.packs : vv if can(vv.version)]])
  pack_data_names = [for v in local.packs : v.name]

  pack_versions       = [for v in local.packs : v.version]
  pack_types          = [for v in local.packs : v.type]
  pack_all_registries = [for v in local.packs : v.registry]


  pack_uids = [for index, v in local.packs : data.spectrocloud_pack.data_packs[index].id]
  pack_mapping = zipmap(
    [for i, v in local.packs : join("", [v.name, "-", v.version])],
    [for v in local.pack_uids : v]
  )
  all_registry_map = {
    for k, v in data.spectrocloud_registry.all_registries :
    v.name => v.id...
  }
}

data "spectrocloud_pack" "data_packs" {
  count = length(local.pack_data_names)

  name         = local.pack_data_names[count.index]
  version      = local.pack_versions[count.index]
  type         = local.pack_types[count.index]
  registry_uid = try(local.all_registry_map[local.pack_all_registries[count.index]][0], "")
}

data "spectrocloud_cluster_profile" "this" {
  for_each = local.profile_names

  name    = split("%", each.value)[0]
  version = split("%", each.value)[1]
}

data "spectrocloud_registry" "all_registries" {
  count = length(local.pack_all_registries)

  name = local.pack_all_registries[count.index]
}

resource "spectrocloud_cluster_profile" "profile_resource" {
  for_each    = var.profiles
  name        = each.value.name
  version     = try(each.value.version, "")
  description = each.value.description
  cloud       = try(each.value.cloudType, "")
  type        = each.value.type
  tags        = try(each.value.tags, [])

  dynamic "pack" {
    for_each = each.value.packs
    content {
      name         = pack.value.name
      type         = try(pack.value.type, "spectro")
      tag          = try(pack.value.version, "")
      registry_uid = try(local.all_registry_map[pack.value.registry][0], "")
      #registry_uid = pack.value.registry_uid
      # uid = (try(pack.value.is_manifest_pack, false)) ? "manifest" : "spectro"
      uid    = lookup(local.pack_mapping, join("", [pack.value.name, "-", try(pack.value.version, "")]), "uid")
      values = try(pack.value.values, "")

      dynamic "manifest" {
        for_each = toset(try(local.cluster_profile_pack_manifests[format("%s-%s", each.value.name, pack.value.name)][0], []))
        content {
          name    = manifest.value.name
          content = manifest.value.content
        }
      }
    }
  }
}
