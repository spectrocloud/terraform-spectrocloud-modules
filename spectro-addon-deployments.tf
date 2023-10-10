resource "spectrocloud_addon_deployment" "this" {
  for_each    = { for x in local.cluster_addon_deployments_map : x.addon_deployment_name => x.value }
  cluster_uid = each.value.cluster_uid != null ? each.value.cluster_uid : "cluster_uid" #data.spectrocloud_cluster.clusters[split("%", each.key)[0]].id
  context = try(each.value.context, "project")

  cluster_profile {

    id = (local.profile_map[format("%s%%%s%%%s",
      each.value.profile.name,
      try(each.value.profile.version, "1.0.0"),
    try(each.value.profile.context, "project"))].id)

    dynamic "pack" {
      for_each = try(each.value.profile.packs, [])
      content {
        name         = pack.value.name
        tag          = try(pack.value.version, "")
        registry_uid = try(local.all_registry_map[pack.value.registry][0], "")
        type         = (try(pack.value.is_manifest_pack, false)) ? "manifest" : "spectro"
        values       = "${(try(pack.value.is_manifest_pack, false)) ?
          local.cluster-profile-pack-map[format("%s%%%s%%%s$%s", each.value.profile.name, try(each.value.profile.version, "1.0.0"), try(each.value.profile.context, "project"), pack.value.name)].values :
          (pack.value.override_type == "values") ?
          pack.value.values :
          (pack.value.override_type == "params" ?
            local.addon_pack_params_replaced[format("%s$%s%%%s%%%s$%s", each.value.cluster_name, each.value.profile.name, try(each.value.profile.version, "1.0.0"), try(each.value.profile.context, "project"), pack.value.name)] :
          local.addon_pack_template_params_replaced[format("%s$%s%%%s%%%s$%s", each.value.cluster_name, each.value.profile.name, try(each.value.profile.version, "1.0.0"), try(each.value.profile.context, "project"), pack.value.name)])
          }"

        dynamic "manifest" {
          for_each = try(local.addon_pack_manifests[format("%s$%s%%%s%%%s$%s", each.value.cluster_name, each.value.profile.name, try(each.value.profile.version, "1.0.0"), try(each.value.profile.context, "project"), pack.value.name)], [])
          content {
            name    = manifest.value.name
            content = manifest.value.content
          }
        }
      }
    }

  }

  timeouts {
    create = try(each.value.profile.timeouts.create, "60m")
    update = try(each.value.profile.timeouts.update, "60m")
    delete = try(each.value.profile.timeouts.delete, "60m")
  }
}
