locals {

  cluster_addon_profiles_map = {
  for v in var.clusters :
  v.name => concat(try(tolist(v.profiles.system), []), concat(try(v.profiles.addons, []), try(v.profiles.addon_deployments, [])))
  }

  addon_pack_params_replaced = { for v in flatten([
  for k, v in local.cluster_addon_profiles_map : [
  for e in v : [
  for p in try(e.packs, []) : {
    name = format("%s$%s%%%s%%%s$%s", k, e.name, try(e.version, "1.0.0"), try(e.context, "project"), p.name)
    value = join("\n", [
    for line in split("\n", try(p.is_manifest_pack, false) ?
    element([for x in local.cluster-profile-pack-map[format("%s%%%s%%%s$%s", e.name, try(e.version, "1.0.0"), try(e.context, "project"), p.name)].manifest : x.content if x.name == p.manifest_name], 0) :
    local.cluster-profile-pack-map[format("%s%%%s%%%s$%s", e.name, try(e.version, "1.0.0"), try(e.context, "project"), p.name)].values) :
    format(
    replace(line, "/'%(${join("|", keys(p.params))})%'/", "%v"),
    [
    for value in flatten(regexall("%(${join("|", keys(p.params))})%", line)) :
    lookup(p.params, value)
    ]...
    )
    ])
  } if p.override_type == "params"
  ]
  ]]) : v.name => v.value
  }

  addon_pack_template_params_replaced = { for v in flatten([
  for k, v in local.cluster_addon_profiles_map : [
  for e in v : [
  for p in try(e.packs, []) : {
    name = format("%s-%s-%s", k, e.name, p.name)
    value = join("\n", flatten([for l in p.params : [
      join("\n", [
      for line in split("\n", try(p.is_manifest_pack, false) ?
      element([for x in local.cluster-profile-pack-map[format("%s%%%s%%%s$%s", e.name, try(e.version, "1.0.0"), try(e.context, "project"), p.name)].manifest : x.content if x.name == p.manifest_name], 0) :
      local.cluster-profile-pack-map[format("%s%%%s%%%s$%s", e.name, try(e.version, "1.0.0"), try(e.context, "project"), p.name)].values) :
      format(
      replace(line, "/%(${join("|", keys(l))})%/", "%s"),
      [
      for value in flatten(regexall("%(${join("|", keys(l))})%", line)) :
      lookup(l, value)
      ]...
      )
      ])
    ]]))
  } if p.override_type == "template"]
  ]
  ]) : v.name => v.value
  }

  addon_pack_manifests = { for v in flatten([
  for k, v in local.cluster_addon_profiles_map : [
  for e in v : [
  for p in try(e.packs, []) : {
    name = format("%s$%s%%%s%%%s$%s", k, e.name, try(e.version, "1.0.0"), try(e.context, "project"), p.name)
    value = [{
      #identifier = format("%s-%s%%%s%%%s-%s-%s", k, e.name, try(e.version, "1.0.0"), try(e.context, "project"), p.name, p.manifest_name)
      name = p.manifest_name
      content = lookup(local.addon_pack_params_replaced, format("%s$%s%%%s%%%s$%s", k, e.name, try(e.version, "1.0.0"), try(e.context, "project"), p.name),
      lookup(local.addon_pack_template_params_replaced, format("%s$%s%%%s%%%s$%s", k, e.name, try(e.version, "1.0.0"), try(e.context, "project"), p.name), "")
      )
    }]
  } if try(p.is_manifest_pack, false)]
  ]
  ]) : v.name => v.value
  }

}

output "debug_addon_pack_manifests" {
  value = local.addon_pack_manifests
}

# not addon specific
output "debug_cluster_profile_pack_map" {
  value = local.cluster-profile-pack-map
}


