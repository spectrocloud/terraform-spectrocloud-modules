locals {

  cluster_system_profiles_map = {
    for v in var.clusters :
    v.name => concat(try([v.profiles.system], []), [])
  }

  // local.cluster_system_profiles_map should contain information provided by user in cluster.yaml file
  system-pack-params-replaced = { for v in flatten([
    for k, v in local.cluster_system_profiles_map : [
      for p in try(v.packs, []) : {
        name = format("%s$%s%%%s%%%s$%s", k, v.name, try(v.version, "1.0.0"), try(v.context, "project"), p.name)
        value = join("\n", [
          for line in split("\n", try(p.is_manifest_pack, false) ?
            element([for x in local.cluster-profile-pack-map[format("%s%%%s%%%s$%s", v.name, try(v.version, "1.0.0"), try(v.context, "project"), p.name)].manifest : x.content if x.name == p.manifest_name], 0) :
          local.cluster-profile-pack-map[format("%s%%%s%%%s$%s", v.name, try(v.version, "1.0.0"), try(v.context, "project"), p.name)].values) :
          format(
            replace(line, "/'%(${join("|", keys(p.params))})%'/", "%v"),
            [
              for value in flatten(regexall("%(${join("|", keys(p.params))})%", line)) :
              lookup(p.params, value)
            ]...
          )
        ])
      } if try(p.override_type == "params", false)
    ]]) : v.name => v.value
  }

  system-pack-template-params-replaced = { for v in flatten([
    for k, v in local.cluster_system_profiles_map : [
      for p in try(v.packs, []) : {
        name = format("%s$%s%%%s%%%s$%s", k, v.name, try(v.version, "1.0.0"), try(v.context, "project"), p.name)
        value = join("\n", flatten([for l in p.params : [
          join("\n", [
            for line in split("\n", try(p.is_manifest_pack, false) ?
              element([for x in local.cluster-profile-pack-map[format("%s%%%s%%%s$%s", v.name, try(v.version, "1.0.0"), try(v.context, "project"), p.name)].manifest : x.content if x.name == p.manifest_name], 0) :
            local.cluster-profile-pack-map[format("%s%%%s%%%s$%s", v.name, try(v.version, "1.0.0"), try(v.context, "project"), p.name)].values) :
            format(
              replace(line, "/%(${join("|", keys(l))})%/", "%s"),
              [
                for value in flatten(regexall("%(${join("|", keys(l))})%", line)) :
                lookup(l, value)
              ]...
            )
          ])
        ]]))
      } if try(p.override_type == "template", false)
    ]]) : v.name => v.value
  }

  system_pack_manifests = { for v in flatten([
  // We have add all addon, system and manifest pack to addon profile maps, hence using global variable local.cluster_addon_profiles_map
  for k, v in local.cluster_addon_profiles_map : [
  for e in v : [
  for p in try(e.packs, []) : {
    name = format("%s$%s%%%s%%%s$%s", k, e.name, try(e.version, "1.0.0"), try(e.context, "project"), p.name)
    value = [{
      #identifier = format("%s-%s%%%s%%%s-%s-%s", k, e.name, try(e.version, "1.0.0"), try(e.context, "project"), p.name, p.manifest_name)
      name = p.manifest_name
      content = lookup(local.addon_pack_params_replaced, format("%s$%s%%%s%%%s$%s", k, e.name, try(e.version, "1.0.0"), try(e.context, "project"), p.name),
        lookup(local.system-pack-template-params-replaced, format("%s$%s%%%s%%%s$%s", k, e.name, try(e.version, "1.0.0"), try(e.context, "project"), p.name), "")
      )
    }]
  } if try(p.is_manifest_pack, false)]
  ]
  ]) : v.name => v.value
  }

}

output "debug_cluster_system_profiles_map" {
  value = local.cluster_system_profiles_map
}

output "debug_system_pack_manifests" {
  value = local.system_pack_manifests
}