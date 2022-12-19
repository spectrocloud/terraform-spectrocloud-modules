
module "Spectro" {
  source = "../../"
  application_deployments = {
  for k in fileset("config/app_deployments", "app-deployment-*.yaml") :
  trimsuffix(k, ".yaml") => yamldecode(file("config/app_deployments/${k}"))
  }
}