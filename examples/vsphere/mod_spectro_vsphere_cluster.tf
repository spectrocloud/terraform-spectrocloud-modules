module "SpectroCluster" {
  source = "../../"
  clusters = {
  for k in fileset("config/cluster", "cluster-*.yaml") :
  trimsuffix(k, ".yaml") => yamldecode(file("config/cluster/${k}"))
  }
}










