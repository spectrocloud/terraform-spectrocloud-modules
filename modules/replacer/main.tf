locals {
  all_objects_params_replaced = tomap({
  for k, v in var.objects : k => yamldecode(templatefile(v, var.params))
  })
}