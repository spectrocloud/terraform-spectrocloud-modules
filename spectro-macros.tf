locals {
  new_macros_iterable = {
    for v in var.macros_list : try(v.project, "") => {
      name  = try(v.project, "")
      value = { for m in v.macros : m.name => m.value }
    }
  }
}

resource "spectrocloud_macros" "macros" {
  for_each = local.new_macros_iterable

  macros  = each.value.value
  project = each.value.name
}
