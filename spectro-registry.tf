locals {
  registry_map    = { for i, registry in var.registries : tostring(i) => registry }
  ecr_keys        = compact([for i, registry in local.registry_map : registry.type == "ecr" ? i : ""])
  ecr_registries  = [for key in local.ecr_keys : lookup(local.registry_map, key)]
  helm_keys       = compact([for i, registry in local.registry_map : registry.type == "helm" ? i : ""])
  helm_registries = [for key in local.helm_keys : lookup(local.registry_map, key)]
}

resource "spectrocloud_registry_oci" "oci_registry" {
  for_each = { for x in local.ecr_registries : x.name => x }

  name       = each.value.name
  type       = each.value.type
  endpoint   = each.value.endpoint
  is_private = true
  credentials {
    credential_type = each.value.credential_type
    arn             = try(each.value.arn, "")
    external_id     = try(each.value.external_id, "")
    access_key = try(each.value.access_key, "")
    secret_key = try(each.value.secret_key, "")
  }
}

resource "spectrocloud_registry_helm" "helm_registry" {
  for_each = { for x in local.helm_registries : x.name => x }

  name       = each.value.name
  endpoint   = each.value.endpoint
  is_private = each.value.is_private
  credentials {
    credential_type = each.value.credential_type
    username        = try(each.value.username, "")
    password        = try(each.value.password, "")
    token           = try(each.value.token, "")
  }
}