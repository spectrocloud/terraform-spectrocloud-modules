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

  packs = flatten([for v in var.profiles : [for vv in v.packs : vv]])
  cluster_profile_pack_manifests = { for v in flatten([
    for v in var.profiles : [
      for p in v.packs : {
        name  = format("%s-%s", v.name, p.name)
        value = try(p.manifests, [])
      }
    ]
    ]) : v.name => v.value
  }
}

data "spectrocloud_cluster_profile" "this" {
  for_each = local.profile_names

  name = each.value
}

resource "spectrocloud_cluster_profile" "profile_resource" {
  for_each    = var.profiles
  name        = each.value.name
  description = each.value.description
  cloud       = "eks"
  type        = each.value.type

  dynamic "pack" {
    for_each = each.value.packs
    content {
      name   = pack.value.name
      type   = try(pack.value.type, "spectro")
      tag    = try(pack.value.version, "")
      values = try(pack.value.values, "")

      dynamic "manifest" {
        for_each = toset(try(local.cluster_profile_pack_manifests[format("%s-%s", each.value.name, pack.value.name)], []))
        content {
          name    = manifest.value.name
          content = manifest.value.content
        }
      }
    }
  }
}
