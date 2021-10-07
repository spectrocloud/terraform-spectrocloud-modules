locals {

  fileset_root      = "./"#join("", [path.module, "/"])
  fileset_subfolder = join("", [local.fileset_root, var.rsubfolder])

  param_files = fileset(local.fileset_subfolder, "param-*.yaml")
  params = {
  for k in local.param_files :
  trimsuffix(k, ".yaml") => yamldecode(file(join("", [var.rsubfolder, "/${k}"])))
  }

  all_params = flatten(
  [
  for k, v in local.params : v
  ]
  )

  all_params_map = zipmap(
  flatten(
  [for item in local.all_params : keys(item)]
  ),
  flatten(
  [for item in local.all_params : values(item)]
  )
  )

  object_files = fileset(local.fileset_subfolder, join("", [var.rprefix, "*.yaml"]))
}