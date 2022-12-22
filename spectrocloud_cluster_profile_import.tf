resource "spectrocloud_cluster_profile_import" "import" {
  for_each = toset(var.cluster_profile_imports)

  context = try(var.cluster_profile_imports_context, "project")
  import_file = try(each.value) # file path to the cluster profile import
}