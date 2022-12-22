locals {
  import_profiles = flatten([for f in var.cluster_profile_imports: f if can(f)])

  cluster_profile_imports = try([for c in local.import_profiles:{
    name = trimprefix(c.import_file_path, ".json")
    value ={
      context = c.context
      import_file_path = c.import_file_path
    }
  }])
  cluster_profile_imports_iterable = { for v in toset(local.cluster_profile_imports): v.name => v.value }
}
