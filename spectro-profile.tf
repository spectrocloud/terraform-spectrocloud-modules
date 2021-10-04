locals {
  packs         = flatten([for v in var.profiles : [for vv in v.packs : vv]])
  pack_names    = [for v in local.packs : v.name]
  pack_versions = [for v in local.packs : v.version]

  count     = length(local.pack_names)
  pack_uids = [for index, v in local.packs : data.spectrocloud_pack.data_packs[index].id]
  pack_mapping = zipmap(
    [for i, v in local.packs : join("", [v.name, "-", v.version])],
    [for v in local.pack_uids : v]
  )
}

data "spectrocloud_pack" "data_packs" {
  count = length(local.pack_names)

  name    = local.pack_names[count.index]
  version = local.pack_versions[count.index]
}

resource "spectrocloud_cluster_profile" "infra" {
  for_each    = var.profiles
  name        = each.value.name
  description = each.value.description
  cloud       = "eks"
  type        = each.value.type

  dynamic "pack" {
    for_each = each.value.packs
    content {
      name   = pack.value.name
      type   = pack.value.type
      tag    = try(pack.value.tag, pack.value.version)
      uid    = lookup(local.pack_mapping, join("", [pack.value.name, "-", pack.value.version]), "")
      values = pack.value.values
    }
  }
}
