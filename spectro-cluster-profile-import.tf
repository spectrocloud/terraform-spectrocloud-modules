resource "spectrocloud_cluster_profile_import" "import" {
  for_each = local.cluster_profile_imports_iterable

  context = try(each.value.context, "project")
  import_file = try(each.value.import_file_path) # file path to the cluster profile import
}

