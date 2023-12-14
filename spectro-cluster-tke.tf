resource "spectrocloud_cluster_tke" "this" {
  for_each      = { for x in local.tke_clusters : x.name => x }
  name          = each.value.name
  context = try(each.value.context, "project")
  apply_setting = try(each.value.apply_setting, "DownloadAndInstall")
  tags          = try(each.value.tags, [])
  skip_completion = try(each.value.skip_completion, true)

  cloud_config {
    region              = each.value.cloud_config.tke_region
    vpc_id              = each.value.cloud_config.tke_vpc_id
    ssh_key_name        = try(each.value.cloud_config.ssh_key_name, null)
    az_subnets          = each.value.cloud_config.tke_subnets
    azs                 = []
    public_access_cidrs = try(each.value.public_access_cidrs, [])
    endpoint_access     = each.value.cloud_config.endpoint_access
  }

  dynamic "cluster_rbac_binding" {
    for_each = try(each.value.cluster_rbac_binding, [])
    content {
      type      = cluster_rbac_binding.value.type
      namespace = try(cluster_rbac_binding.value.namespace, "")

      role = {
        kind = cluster_rbac_binding.value.role.kind
        name = cluster_rbac_binding.value.role.name
      }

      dynamic "subjects" {
        for_each = try(cluster_rbac_binding.value.subjects, [])

        content {
          type      = subjects.value.type
          name      = subjects.value.name
          namespace = try(subjects.value.namespace, "")
        }
      }
    }
  }

  dynamic "namespaces" {
    for_each = try(each.value.namespaces, [])

    content {
      name = namespaces.value.name
      resource_allocation = {
        cpu_cores  = try(namespaces.value.resource_allocation.cpu_cores, "")
        memory_MiB = try(namespaces.value.resource_allocation.memory_MiB, "")
      }
    }
  }

  cluster_profile {
    id = (local.profile_map[format("%s%%%s%%%s",
    each.value.profiles.infra.name,
    try(each.value.profiles.infra.version, "1.0.0"),
    try(each.value.profiles.infra.context, "project"))].id)

    dynamic "pack" {
      for_each = try(each.value.profiles.infra.packs, [])
      content {
        name         = pack.value.name
        tag          = try(pack.value.version, "")
        registry_uid = try(local.all_registry_map[pack.value.registry][0], "")
        type         = (try(pack.value.is_manifest_pack, false)) ? "manifest" : "spectro"
        values       = "${(try(pack.value.is_manifest_pack, false)) ?
        local.cluster-profile-pack-map[format("%s%%%s%%%s$%s", each.value.profiles.infra.name, try(each.value.profiles.infra.version, "1.0.0"), try(each.value.profiles.infra.context, "project"), pack.value.name)].values :
        (pack.value.override_type == "values") ?
        pack.value.values :
        (pack.value.override_type == "params" ?
          local.infra-pack-params-replaced[format("%s$%s%%%s%%%s$%s", each.value.name, each.value.profiles.infra.name, try(each.value.profiles.infra.version, "1.0.0"), try(each.value.profiles.infra.context, "project"), pack.value.name)] :
        local.infra-pack-template-params-replaced[format("%s$%s%%%s%%%s$%s", each.value.name, each.value.profiles.infra.name, try(each.value.profiles.infra.version, "1.0.0"), try(each.value.profiles.infra.context, "project"), pack.value.name)])
        }"

        dynamic "manifest" {
          for_each = try([local.infra_pack_manifests[format("%s$%s%%%s%%%s$%s", each.value.name, each.value.profiles.infra.name, try(each.value.profiles.infra.version, "1.0.0"), try(each.value.profiles.infra.context, "project"), pack.value.name)]], [])
          content {
            name    = manifest.value.name
            content = manifest.value.content
          }
        }
      }
    }
  }

  dynamic "cluster_profile" {
    for_each = try(each.value.profiles.addons, [])

    content {
      id = (local.profile_map[format("%s%%%s%%%s",
      cluster_profile.value.name,
      try(cluster_profile.value.version, "1.0.0"),
      try(cluster_profile.value.context, "project"))].id)

      dynamic "pack" {
        for_each = try(cluster_profile.value.packs, [])
        content {
          name         = pack.value.name
          tag          = try(pack.value.version, "")
          registry_uid = try(local.all_registry_map[pack.value.registry][0], "")
          type         = (try(pack.value.is_manifest_pack, false)) ? "manifest" : "spectro"
          values       = "${(try(pack.value.is_manifest_pack, false)) ?
          local.cluster-profile-pack-map[format("%s%%%s%%%s$%s", cluster_profile.value.name, try(cluster_profile.value.version, "1.0.0"), try(cluster_profile.value.context, "project"), pack.value.name)].values :
          (pack.value.override_type == "values") ?
          pack.value.values :
          (pack.value.override_type == "params" ?
             local.addon_pack_params_replaced[format("%s$%s%%%s%%%s$%s", each.value.name, cluster_profile.value.name, try(cluster_profile.value.version, "1.0.0"), try(cluster_profile.value.context, "project"), pack.value.name)] :
          local.addon_pack_template_params_replaced[format("%s$%s%%%s%%%s$%s", each.value.name, cluster_profile.value.name, try(cluster_profile.value.version, "1.0.0"), try(cluster_profile.value.context, "project"), pack.value.name)])
          }"

          dynamic "manifest" {
            for_each = try(local.addon_pack_manifests[format("%s$%s%%%s%%%s$%s", each.value.name, try(cluster_profile.value.version, "1.0.0"), try(cluster_profile.value.context, "project"), pack.value.name)], [])
            content {
              name    = manifest.value.name
              content = manifest.value.content
            }
          }
        }
      }
    }
  }

  cloud_account_id = local.tke_cloud_account_map[each.value.cloud_account]

  dynamic "machine_pool" {
    for_each = each.value.node_groups
    content {
      name          = machine_pool.value.name
      count         = machine_pool.value.count
      min           = try(machine_pool.value.min, 0)
      max           = try(machine_pool.value.max, 0)
      instance_type = machine_pool.value.instance_type
      az_subnets    = machine_pool.value.worker_subnets
      disk_size_gb  = machine_pool.value.disk_size_gb
      azs           = []

      additional_labels = try(machine_pool.value.additional_labels, tomap({}))
      dynamic "node" {
        for_each = try(machine_pool.value.node, [])
        content {
          node_id = node.value.node_id
          action  = node.value.action
        }
      }

      dynamic "taints" {
        for_each = try(machine_pool.value.taints, [])

        content {
          key    = taints.value.key
          value  = taints.value.value
          effect = taints.value.effect
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

  timeouts {
    create = try(each.value.timeouts.create, "60m")
    delete = try(each.value.timeouts.delete, "60m")
  }
}