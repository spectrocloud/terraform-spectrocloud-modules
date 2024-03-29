locals {
  accounts_params = { ACCOUNT_DEV_NAME = "dev-030", ACCOUNT_PROD_NAME = "prod-004" }
  appliances_params = {}
  bsl_params      = { BSL_NAME = "qa-sharma" }
  profile_params = {
    SPECTRO_REPO_URL       = "https://registry.spectrocloud.com",
    REPO_URL               = "593235963820.dkr.ecr.us-west-2.amazonaws.com",
    OIDC_CLIENT_ID         = "5ajs8pq0gatbgpjejld96fldrn",
    OIDC_ISSUER_URL        = "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_ajvPoziaS",
    RABBITMQ_PACK_VERSION  = "8.15.2",
    string                 = "$${string}",
    ADDON_SPECTRO_REPO_URL = "https://addon-registry.spectrocloud.com",
  }
  projects_params = {}
  clusters_params = {}
}

module "SpectroOrg" {
  source = "../../"
  //source = "git::https://github.com/spectrocloud/terraform-spectrocloud-modules.git?ref=edge-native-changes"

  accounts = {
    for k in fileset("config/account", "account-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(templatefile("config/account/${k}", local.accounts_params))
  }

  appliances = {
    for k in fileset("config/appliance", "appliance-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(templatefile("config/appliance/${k}", local.appliances_params))
  }

  profiles = {
    for k in fileset("config/profile", "profile-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(templatefile("config/profile/${k}", local.profile_params))
  }
}


module "SpectroProject" {
  depends_on = [module.SpectroOrg]
  source = "../../"
  //source = "git::https://github.com/spectrocloud/terraform-spectrocloud-modules.git?ref=edge-native-changes"

  clusters = {
    for k in fileset("config/cluster", "cluster-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(templatefile("config/cluster/${k}", local.accounts_params))
  }
}
