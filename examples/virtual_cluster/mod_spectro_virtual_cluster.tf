module "Spectro"{
  source = "../../"
  virtual_clusters = {
  for k in fileset("config/virtual_clusters", "virtual-cluster-*.yaml") :
  trimsuffix(k, ".yaml") => yamldecode(file("config/virtual_clusters/${k}"))
  }
}
