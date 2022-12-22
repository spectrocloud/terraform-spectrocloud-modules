module "Spectro" {
  source = "../../"
  cluster_profile_imports_context = var.sc_context
  cluster_profile_imports = [
  for k in fileset("config/import_profiles", "cluster-profile-import-*.json") :
  abspath("config/import_profiles/${k}")
  ]
}