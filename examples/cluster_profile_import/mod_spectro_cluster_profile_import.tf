module "Spectro" {
  source = "../../"
  cluster_profile_imports = {
  for k in fileset("config/import_profiles", "import-cluster-profile-*.yaml") :
  trimsuffix(k, ".yaml") => yamldecode(file("config/import_profiles/${k}"))
  }
}
