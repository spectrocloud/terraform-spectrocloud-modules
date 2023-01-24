locals {
  macros = toset(flatten([
  for v in var.macros : [
  for i, m in v.macros : {
    name  = format("%s%%%s", m.name, try(v.project, "tenant"))
    value = {
      name    = m.name
      value   = m.value
      project = try(v.project, "")
    }
  }
  ]
  ]))

  macros_iterable = { for macro in local.macros: macro.name => macro.value }
}

resource "spectrocloud_macro" "macro" {
  for_each = local.macros_iterable

  name    = each.value.name
  value   = each.value.value
  project = each.value.project
}
