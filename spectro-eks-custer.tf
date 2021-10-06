locals {

  infra-pack-params-replaced = { for v in flatten([
  for k, v in local.cluster_infra_profiles_map : [
  for p in try(v.packs, []) : {
    name = format("%s-%s-%s", k, v.name, p.name)
    value = join("\n", [
    for line in split("\n", try(p.is_manifest_pack, false) ? element([for x in local.cluster-profile-pack-map[format("%s-%s", v.name, p.name)].manifest: x.content if x.name == p.manifest_name], 0) : local.cluster-profile-pack-map[format("%s-%s", v.name, p.name)].values) :
    format(
    replace(line, "/%(${join("|", keys(p.params))})%/", "%s"),
    [
    for value in flatten(regexall("%(${join("|", keys(p.params))})%", line)) :
    lookup(p.params, value)
    ]...
    )
    ])
  } if p.override_type == "params"
  ]]): v.name => v.value
  }

  infra-pack-template-params-replaced = { for v in flatten([
  for k, v in local.cluster_infra_profiles_map : [
  for p in try(v.packs, []) : {
    name = format("%s-%s-%s", k, v.name, p.name)
    value = join("\n", flatten([for l in p.template_values: [
      join("\n", [
      for line in split("\n", try(p.is_manifest_pack, false) ? element([for x in local.cluster-profile-pack-map[format("%s-%s", v.name, p.name)].manifest: x.content if x.name == p.manifest_name], 0) : local.cluster-profile-pack-map[format("%s-%s", v.name, p.name)].values) :
      format(
      replace(line, "/%(${join("|", keys(l))})%/", "%s"),
      [
      for value in flatten(regexall("%(${join("|", keys(l))})%", line)) :
      lookup(l, value)
      ]...
      )
      ])
    ]]))
  } if p.override_type == "template"
  ]]): v.name => v.value
  }

  addon_pack_params_replaced = { for v in flatten([
  for k, v in local.cluster_addon_profiles_map : [
  for e in v :[
  for p in try(e.packs, []) : {
    name = format("%s-%s-%s", k, e.name, p.name)
    value = join("\n", [
    for line in split("\n", try(p.is_manifest_pack, false) ? element([for x in local.cluster-profile-pack-map[format("%s-%s", e.name, p.name)].manifest: x.content if x.name == p.manifest_name], 0) : local.cluster-profile-pack-map[format("%s-%s", e.name, p.name)].values) :
    format(
    replace(line, "/%(${join("|", keys(p.params))})%/", "%s"),
    [
    for value in flatten(regexall("%(${join("|", keys(p.params))})%", line)) :
    lookup(p.params, value)
    ]...
    )
    ])
  } if p.override_type == "params"
  ]
  ]]): v.name => v.value
  }

  addon_pack_template_params_replaced = { for v in flatten([
  for k, v in local.cluster_addon_profiles_map : [
  for e in v :[
  for p in try(e.packs, []) : {
    name = format("%s-%s-%s", k, e.name, p.name)
    value = join("\n", flatten([for l in p.template_values: [
      join("\n", [
      for line in split("\n", try(p.is_manifest_pack, false) ? element([for x in local.cluster-profile-pack-map[format("%s-%s", e.name, p.name)].manifest: x.content if x.name == p.manifest_name], 0) : local.cluster-profile-pack-map[format("%s-%s", e.name, p.name)].values) :
      format(
      replace(line, "/%(${join("|", keys(l))})%/", "%s"),
      [
      for value in flatten(regexall("%(${join("|", keys(l))})%", line)) :
      lookup(l, value)
      ]...
      )
      ])
    ]]))
  }if p.override_type == "template"]
  ]
  ]): v.name => v.value
  }

  infra_pack_manifests = { for v in flatten([
  for k, v in local.cluster_infra_profiles_map : [
  for p in try(v.packs, []) : {
    name = format("%s-%s-%s", k, v.name, p.name)
    value = {
      identifier = format("%s-%s-%s-%s", k, v.name, p.name, p.manifest_name)
      name = p.manifest_name
      content = lookup(local.infra-pack-params-replaced, format("%s-%s-%s", k, v.name, p.name), lookup(local.infra-pack-template-params-replaced, format("%s-%s-%s", k, v.name, p.name), ""))
    }
  } if try(p.is_manifest_pack, false)
  ]
  ]): v.name => v.value
  }

  addon_pack_manifests = { for v in flatten([
  for k, v in local.cluster_addon_profiles_map : [
  for e in v :[
  for p in try(e.packs, []) : {
    name = format("%s-%s-%s", k, e.name, p.name)
    value = [{
      identifier = format("%s-%s-%s-%s", k, e.name, p.name, p.manifest_name)
      name = p.manifest_name
      content = lookup(local.addon_pack_params_replaced, format("%s-%s-%s", k, e.name, p.name), lookup(local.addon_pack_template_params_replaced, format("%s-%s-%s", k, e.name, p.name), ""))
    }]
  } if try(p.is_manifest_pack, false)]
  ]
  ]): v.name => v.value
  }

}

resource "spectrocloud_cluster_eks" "this" {
  for_each = var.clusters
  name     = each.value.name

  cluster_profile {
    id = local.profile_map[each.value.profiles.infra.name].id

    dynamic "pack" {
      for_each = each.value.profiles.infra.packs
      content {
        name = pack.value.name
        tag = try(pack.value.version, "")
        type = (try(pack.value.is_manifest_pack, false)) ? "manifest" : "spectro"
        values = (try(pack.value.is_manifest_pack, false)) ? local.cluster-profile-pack-map[format("%s-%s", each.value.profiles.infra.name, pack.value.name)].values : (pack.value.override_type == "values") ? pack.value.values : (pack.value.override_type == "params" ? local.infra-pack-params-replaced[format("%s-%s-%s", each.value.name, each.value.profiles.infra.name, pack.value.name)] : local.infra-pack-template-params-replaced[format("%s-%s-%s", each.value.name, each.value.profiles.infra.name, pack.value.name)])

        dynamic "manifest" {
          for_each = try([local.infra_pack_manifests[format("%s-%s-%s", each.value.name, each.value.profiles.infra.name, pack.value.name)]], [])
          content {
            name = manifest.value.name
            content = manifest.value.content
          }
        }
      }
    }
  }

  dynamic cluster_profile {
    for_each =  try(each.value.profiles.addons, [])

    content {
      id = local.profile_map[cluster_profile.value.name].id

      dynamic "pack" {
        for_each = try(cluster_profile.value.packs, [])
        content {
          name = pack.value.name
          tag = try(pack.value.version, "")
          type = (try(pack.value.is_manifest_pack, false)) ? "manifest" : "spectro"
          values = (try(pack.value.is_manifest_pack, false)) ? local.cluster-profile-pack-map[format("%s-%s", cluster_profile.value.name, pack.value.name)].values : (pack.value.override_type == "values") ? pack.value.values : (pack.value.override_type == "params" ? local.addon_pack_params_replaced[format("%s-%s-%s", each.value.name, cluster_profile.value.name, pack.value.name)] : local.addon_pack_template_params_replaced[format("%s-%s-%s", each.value.name, cluster_profile.value.name, pack.value.name)])

          dynamic "manifest" {
            for_each = try(local.addon_pack_manifests[format("%s-%s-%s", each.value.name, cluster_profile.value.name, pack.value.name)], [])
            content {
              name = manifest.value.name
              content = manifest.value.content
            }
          }
        }
      }
    }
  }

  cloud_account_id = local.cloud_account_map[each.value.cloud_account]

  cloud_config {
    region              = each.value.cloud_config.aws_region
    vpc_id              = each.value.cloud_config.aws_vpc_id
    az_subnets          = each.value.cloud_config.eks_subnets
    azs                 = []
    public_access_cidrs = []
    endpoint_access     = each.value.cloud_config.endpoint_access
  }

  dynamic "machine_pool" {
    for_each = each.value.node_groups
    content {
      name          = machine_pool.value.name
      count         = machine_pool.value.count
      instance_type = machine_pool.value.instance_type
      az_subnets    = machine_pool.value.worker_subnets
      disk_size_gb  = machine_pool.value.disk_size_gb
      azs           = []
    }
  }

  dynamic "fargate_profile" {
    for_each = try(each.value.fargate_profiles, [])
    content {
      name            = fargate_profile.value.name
      subnets         = fargate_profile.value.subnets
      additional_tags = fargate_profile.value.additional_tags
      dynamic "selector" {
        for_each = fargate_profile.value.selectors
        content {
          namespace = selector.value.namespace
          labels    = selector.value.labels
        }
      }
    }
  }

  dynamic "backup_policy" {
    for_each = try(tolist([each.value.backup_policy]), [])
    content {
      schedule                  = backup_policy.value.schedule
      backup_location_id        = local.bsl_map[backup_policy.value.backup_location]
      prefix                    = backup_policy.value.prefix
      expiry_in_hour            = 7200
      include_disks             = true
      include_cluster_resources = true
    }
  }

  dynamic "scan_policy" {
    for_each = try(tolist([each.value.scan_policy]), [])
    content {
      configuration_scan_schedule = scan_policy.value.configuration_scan_schedule
      penetration_scan_schedule   = scan_policy.value.penetration_scan_schedule
      conformance_scan_schedule   = scan_policy.value.conformance_scan_schedule
    }
  }
}
