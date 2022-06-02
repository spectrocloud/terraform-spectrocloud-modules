locals {
  macros = toset(flatten([
  for v in var.macros : [
  for m in v.macros : {
    name  = format("%s%%%s", m.name, v.project)
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

output "macros" {
  value = spectrocloud_macro.macro
}

resource "spectrocloud_macro" "macro" {
  for_each = local.macros_iterable

  name    = each.value.name
  value   = each.value.value
  project = each.value.project
}
