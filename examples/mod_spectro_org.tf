/*module "fetcher_accounts" {
  source     = "./modules/fetcher"
  rsubfolder = local.accounts_folder
  rprefix    = "account-"
}*/

locals {
  accounts_params = { ACCOUNT_DEV_NAME = "ehs-dev-030", ACCOUNT_PROD_NAME = "ehs-stg-004" }

  bsl_params  = { BSL_NAME = "qa-sharma" }

  profile_params = {
    SPECTRO_REPO_URL = "https://registry.spectrocloud.com",
    REPO_URL         = "593235963820.dkr.ecr.us-west-2.amazonaws.com",

    OIDC_CLIENT_ID  = "5ajs8pq0gatbgpjejld96fldrn",
    OIDC_ISSUER_URL = "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_ajvPoziaS",

    RABBITMQ_PACK_VERSION = "8.15.2",

    string = "$${string}",

    ADDON_SPECTRO_REPO_URL = "https://addon-registry.gehc.spectrocloud.com",
  }

  projects_params = {}

  clusters_params = {}

}

module "SpectroOrg" {
  source          = "github.com/spectrocloud/terraform-spectrocloud-modules"
  sc_host         = ""    #e.g: api.spectrocloud.com (for SaaS)
  sc_username     = "" #e.g: user1@abc.com
  sc_password     = ""             #e.g: supereSecure1!
  sc_project_name = ""                       #e.g: Default

  /*accounts = tomap({
    for k, v in module.fetcher_accounts.object_files :
    k => yamldecode(templatefile(join("", [local.accounts_folder, "/${k}"]), local.accounts_params))
  })*/

  accounts = {
    for k in fileset("config/account", "account-*.yaml") :
  trimsuffix(k, ".yaml") => yamldecode(templatefile("config/account/${k}", local.accounts_params))
  }

  bsls = {
    for k in fileset("config/bsl", "bsl-*.yaml") :
  trimsuffix(k, ".yaml") => yamldecode(templatefile("config/bsl/${k}", local.bsl_params))
  }

  profiles = {
    for k in fileset("config/profile", "profile-*.yaml") :
  trimsuffix(k, ".yaml") => yamldecode(templatefile("config/profile/${k}", local.profile_params))
  }

  projects ={
    for k in fileset("config/project", "project-*.yaml") :
  trimsuffix(k, ".yaml") => yamldecode(templatefile("config/project/${k}", local.projects_params))
  }

  teams = {
  for k in fileset("config/project", "team-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(templatefile("config/project/${k}", {}))
  }

  /*clusters = tomap({
    for k, v in toset([
      "cluster-eks-test.yaml",
    ]) :
    k => yamldecode(file(join("", [local.clusters_folder, "/${k}"])))
  })*/
}