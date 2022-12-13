locals {
  application_profiles = toset(flatten([
  for v in var.application_profiles : [
    {
      name  = format("%s%%%s", v.name, v.context)
      value = {
        name    = v.name
        version = v.version
        context = v.context
        tags    = try(v.tags, [])
        description = try(v.description, "")
        cloud = try(v.cloud, "all")
        pack = try(tolist(
          [
            for index,pack in v.pack:{
            name = format("%s-%s",pack.name, tostring(index))
            value = {
              name = pack.name
              type = pack.type
              registry_uid = try(pack.registry_uid, "")
              source_app_tier = try(pack.source_app_tier, "")
              values = try(pack.values, "")
#              manifest = try(tomap({
#                name = pack.manifest.name
#                content = pack.manifest.content
#              }
#              ),{})
              manifest = try(tolist([
                for i,mf in pack.manifest:{
                name = format("%s-%s",mf.name, tostring(i))
                value = {
                  name = mf.name
                  content = mf.content
                }
              }
              ]),[])

              properties = try(pack.properties, {})

#              properties = try(tomap(
#                  for n,val in pack.properties{
#                  n = val,
#                }
#              ), {})
            }
          }
          ]
        ))
      }
    }
  ]
  ]))

  application_profiles_iterable = { for app in local.application_profiles: app.name => app.value }
}

resource "spectrocloud_application_profile" "app" {
  for_each = local.application_profiles_iterable

  name    = each.value.name
  version = each.value.version
  context = each.value.context
  tags    = each.value.tags
  description = each.value.description
  cloud = each.value.cloud
  dynamic "pack" {
    for_each = {for pac in each.value.pack: pac.name => pac.value }
    content {
      name = pack.value.name
      type = pack.value.type
      registry_uid = pack.value.registry_uid
      source_app_tier = pack.value.source_app_tier
      values = pack.value.values
#      manifest = pack.value.manifest
      properties = pack.value.properties
      dynamic "manifest" {
        for_each = {for mf in pack.value.manifest: mf.name => mf.value}
        content {
          name = manifest.value.name
          content = manifest.value.content
        }
      }
    }
  }

}
