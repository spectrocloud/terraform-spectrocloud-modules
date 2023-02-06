resource "spectrocloud_cluster_vsphere" "this" {
  for_each      = { for x in local.vsphere_clusters : x.name => x }
  name          = each.value.name
  tags          = try(each.value.tags, [])
  cloud_account_id = data.spectrocloud_cloudaccount_vsphere.this[each.value.cloud_account].id

  cloud_config {
    ssh_key      = each.value.cloud_config.ssh_key
    static_ip    = each.value.cloud_config.static_ip
    network_type = each.value.cloud_config.network_type
    datacenter   = each.value.cloud_config.datacenter
    folder       = each.value.cloud_config.folder
    image_template_folder = can(each.value.cloud_config.image_template_folder) ? each.value.cloud_config.image_template_folder : null
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

  #infra profile
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
            for_each = try(local.addon_pack_manifests[format("%s$%s%%%s%%%s$%s", each.value.name, cluster_profile.value.name, try(cluster_profile.value.version, "1.0.0"), try(cluster_profile.value.context, "project"), pack.value.name)], [])
            content {
              name    = manifest.value.name
              content = manifest.value.content
            }
          }
        }
      }
    }
  }

  dynamic "machine_pool" {
    for_each = each.value.node_groups
    content {
      name                    = machine_pool.value.name
      control_plane           = try(machine_pool.value.control_plane, false)
      control_plane_as_worker = try(machine_pool.value.control_plane_as_worker, false)
      count                   = machine_pool.value.count
      update_strategy         = try(machine_pool.value.update_strategy, "RollingUpdateScaleOut")

      additional_labels = try(machine_pool.value.additional_labels, tomap({}))

      dynamic "taints" {
        for_each = try(machine_pool.value.taints, [])

        content {
          key    = taints.value.key
          value  = taints.value.value
          effect = taints.value.effect
        }
      }
      dynamic "placement" {
        for_each = machine_pool.value.placement
        content {
          cluster       = placement.value.cluster
          resource_pool = placement.value.resource_pool
          datastore     = placement.value.datastore
          network       = placement.value.network
          static_ip_pool_id = placement.value.static_ip_pool_id
        }
      }

      instance_type {
        disk_size_gb = machine_pool.value.disk_size_gb
        memory_mb    = machine_pool.value.memory_mb
        cpu          = machine_pool.value.cpu
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
