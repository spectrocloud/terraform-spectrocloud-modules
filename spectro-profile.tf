locals {
  infra_profile_names = "${[for v in var.clusters :
        format("%s%%%s%%%s", v.profiles.infra.name, try(v.profiles.infra.version, "1.0.0"), try(v.profiles.infra.context, "project"))
        ]}"

  system_profile_names = "${setunion(flatten([for v in local.libvirt_clusters :
        format("%s%%%s%%%s", v.profiles.system.name, try(v.profiles.system.version, "1.0.0"), try(v.profiles.system.context, "project"))
        ]),
        flatten([for v in local.edge_vsphere_clusters :
        format("%s%%%s%%%s", v.profiles.system.name, try(v.profiles.system.version, "1.0.0"), try(v.profiles.system.context, "project"))
        ]),
        flatten([for v in local.edge_clusters :
        format("%s%%%s%%%s", v.profiles.system.name, try(v.profiles.system.version, "1.0.0"), try(v.profiles.system.context, "project"))
        ]),)}"

  addon_profile_names = flatten([
    for v in var.clusters : "${[
      for k in can(v.profiles.addons) ? v.profiles.addons : try(v.profiles.addon_deployments, []) : format("%s%%%s%%%s", k.name, try(k.version, "1.0.0"), try(k.context, "project"))
      ]
    }"
  ])

  profile_names = toset(concat(concat(local.infra_profile_names, local.addon_profile_names), tolist(local.system_profile_names)))

  profile_names_map = {
    for x in flatten([
      for key in local.profile_names : {
        name  = split("%", key)[0]
        version = split("%", key)[1]
        context = split("%", key)[2]
      }
    ]) :
    format("%s%%%s%%%s", x.name, x.version, x.context) => format("%s%%%s%%%s", x.name, x.version, x.context)
  }

  profile_map = { //profiles is map of profile name and complete cluster profile object
    for x in flatten([
      for k, p in data.spectrocloud_cluster_profile.this : { name = format("%s%%%s%%%s", p.name, try(p.version, "1.0.0"), try(p.context, "project")), profile = p }
    ]) :
    x.name => x.profile
  }

  cluster-profile-pack-map = {
    for x in flatten([
      for k, v in data.spectrocloud_cluster_profile.this : [
        for p in v.pack : { name = format("%s%%%s%%%s$%s", v.name, try(v.version, "1.0.0"), try(v.context, "project"), p.name), pack = p }
    ]]) :
    x.name => x.pack
  }

  cluster_infra_profiles_map = {
    for v in var.clusters :
    v.name => v.profiles.infra
  }

  cluster_addon_deployments_map = {
    for x in flatten([
      for k, v in var.clusters : [
        for p in try(v.profiles.addon_deployments, []) : {
          addon_deployment_name = format("%s%%%s", v.name, p.name),
          value = {
                addon_deployment_name = format("%s%%%s", v.name, p.name),
                value = {
                  cluster_uid = data.spectrocloud_cluster.clusters[v.name].id
                  cluster_name = v.name
                  profile = p
                }
              }
            }
          ]]) :
          x.addon_deployment_name => x.value
  }

  cluster_addon_profiles_map = {
    for v in var.clusters :
    v.name => can(v.profiles.addons) ? v.profiles.addons : try(v.profiles.addon_deployments, [])
  }

  cluster_profile_pack_manifests = { for v in flatten([
    for v in var.profiles : [
      for p in v.packs : {
        name  = format("%s%%%s%%%s%%%s", v.name, try(v.version, "1.0.0"), try(v.context, "project"), p.name)
        value = try(p.manifests, [])
      }
    ]
    ]) : v.name => v.value...
  }

  packs           = flatten([for v in var.profiles : [for vv in v.packs : vv if can(vv.version)]])
  pack_data_names = [for v in local.packs : v.name]

  pack_versions       = [for v in local.packs : v.version]
  pack_types          = [for v in local.packs : v.type]
  pack_all_registries = [for v in local.packs : try(v.registry, "")]


  pack_uids = [for index, v in local.packs : data.spectrocloud_pack.data_packs[index].id]
  pack_mapping = zipmap(
    [for i, v in local.packs : join("", [v.name, "-", v.version])],
    [for v in local.pack_uids : v]
  )
  all_registry_map = {
    for k, v in data.spectrocloud_registry.all_registries :
    v.name => v.id... if v.name != null
  }

  profiles_iterable = { for key, profile in var.profiles : join("", [profile.name, "%", try(profile.version, "1.0.0"), "%", try(profile.context, "project")]) => profile }

}

data "spectrocloud_pack" "data_packs" {
  count = length(local.pack_data_names)

  name         = local.pack_data_names[count.index]
  version      = local.pack_versions[count.index]
  type         = local.pack_types[count.index]
  registry_uid = try(local.all_registry_map[local.pack_all_registries[count.index]][0], "")
}

data "spectrocloud_cluster_profile" "this" {
  depends_on = [spectrocloud_cluster_profile.profile_resource] // need to be able to create all profiles before using datasource
  for_each = local.profile_names_map

  name  = split("%", each.value)[0]
  version = split("%", each.value)[1]
  context = split("%", each.value)[2]
}

data "spectrocloud_registry" "all_registries" {
  count = length(local.pack_all_registries)

  name = local.pack_all_registries[count.index]
}

resource "spectrocloud_cluster_profile" "profile_resource" {
  for_each    = local.profiles_iterable
  name        = each.value.name
  version     = try(each.value.version, "1.0.0")
  context     = try(each.value.context, "project")
  description = each.value.description
  cloud       = try(each.value.cloudType, "")
  type        = each.value.type
  tags        = try(each.value.tags, null)

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
        for_each = toset(try(local.cluster_profile_pack_manifests[format("%s%%%s%%%s%%%s", each.value.name, try(each.value.version, "1.0.0"), try(each.value.context, "project"), pack.value.name)][0], []))
content {
          name    = manifest.value.name
          content = manifest.value.content
        }
      }
    }
  }
}
