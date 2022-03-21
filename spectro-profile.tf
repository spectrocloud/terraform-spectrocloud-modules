locals {
  infra_profile_names = [for v in var.clusters : v.profiles.infra.name]

  addon_profile_names = flatten([
    for v in var.clusters : [
      for k in try(v.profiles.addons, []) : k.name
  ]])

  profile_names = toset(concat(local.infra_profile_names, local.addon_profile_names))

  profile_map = { //profiles is map of profile name and complete cluster profile object
    for k, v in data.spectrocloud_cluster_profile.this :
    v.name => v
  }

  cluster-profile-pack = flatten([
    for k, v in data.spectrocloud_cluster_profile.this : [
      for p in v.pack : { format("%s-%s", k, p.name) = p }
  ]])


  cluster-profile-pack-map = {
    for x in flatten([
      for k, v in data.spectrocloud_cluster_profile.this : [
        for p in v.pack : { name = format("%s-%s", k, p.name), pack = p }
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

  packs         = flatten([for v in var.profiles : [for vv in v.packs : vv if can(vv.version)]])
  pack_data_names    = [for v in local.packs : v.name]

  pack_versions = [for v in local.packs : v.version]
  pack_types = [for v in local.packs : v.type]
  pack_all_registries = [for v in local.packs : v.registry]
  pack_registries = [for v in local.packs : v.registry if v.type != "helm" && v.registry != ""]
  helm_registries = [for v in local.packs : v.registry if v.type == "helm"]


  pack_uids = [for index, v in local.packs : data.spectrocloud_pack.data_packs[index].id]
  pack_mapping = zipmap(
    [for i, v in local.packs : join("", [v.name, "-", v.version])],
    [for v in local.pack_uids : v]
  )
  registry_pack_map = {
    for k, v in data.spectrocloud_registry_pack.registry_pack :
    v.name => v.id...
  }
  registry_helm_map = {
    for k, v in data.spectrocloud_registry_helm.registry_helm :
    v.name => v.id...
  }
}

output "registry_pack_map" {
  value = local.registry_helm_map["helm-blr-ees"][0]
}

data "spectrocloud_pack" "data_packs" {
  count = length(local.pack_data_names)

  name    = local.pack_data_names[count.index]
  version = local.pack_versions[count.index]
  type = local.pack_types[count.index]
  registry_uid = try(try(local.registry_pack_map[local.pack_all_registries[count.index]][0], local.registry_helm_map[local.pack_all_registries[count.index]][0]), "")
}

data "spectrocloud_cluster_profile" "this" {
  for_each = local.profile_names

  name = each.value
}

data "spectrocloud_registry_pack" "registry_pack" {
  count = length(local.pack_registries)

  name    = local.pack_registries[count.index]
}

data "spectrocloud_registry_helm" "registry_helm" {
  count = length(local.helm_registries)

  name    = local.helm_registries[count.index]
}

resource "spectrocloud_cluster_profile" "profile_resource" {
  for_each    = var.profiles
  name        = each.value.name
  description = each.value.description
  cloud       = try(each.value.cloudType, "")
  type        = each.value.type

  dynamic "pack" {
    for_each = each.value.packs
    content {
      name   = pack.value.name
      type   = try(pack.value.type, "spectro")
      tag    = try(pack.value.version, "")
      registry_uid = try(try(local.registry_pack_map[pack.value.registry][0], local.registry_helm_map[pack.value.registry][0]), "")
      #registry_uid = pack.value.registry_uid
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
