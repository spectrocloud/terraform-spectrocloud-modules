module "Spectro" {
  source = "../../"
  cluster_groups = {
  for k in fileset("config/cluster_groups", "cluster-group-*.yaml") :
  trimsuffix(k, ".yaml") => yamldecode(file("config/cluster_groups/${k}"))
  }
}