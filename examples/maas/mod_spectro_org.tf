locals {
  accounts_params = {}
  profile_params = {}
  clusters_params = {}
}

module "SpectroOrg" {
  source = "../../"

  /*accounts = {
    for k in fileset("config/account", "account-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(templatefile("config/account/${k}", local.accounts_params))
  }*/

  profiles = {
    for k in fileset("config/profile", "profile-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(templatefile("config/profile/${k}", local.profile_params))
  }


}

module "SpectroProject" {
  depends_on = [module.SpectroOrg]
  source = "../../"

  clusters = {
    for k in fileset("config/cluster", "cluster-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(templatefile("config/cluster/${k}", local.clusters_params))
  }
}
