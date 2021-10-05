/*module "fetcher_accounts" {
  source     = "../modules/fetcher"
  rsubfolder = local.accounts_folder
  rprefix    = "account-"
}*/

locals {
  accounts_folder = "./"
  accounts_params = { ACCOUNT_DEV_NAME = "ehs-dev-030", ACCOUNT_PROD_NAME = "ehs-stg-004" }

  bsls_folder = "./"
  bsl_params  = { BSL_NAME = "ehs-org-dev-storage-203" }

  profiles_folder = "./config/profile-2.0"
  profile_params = {
    SPECTRO_REPO_URL = "https://registry.spectrocloud.com",
    REPO_URL         = "593235963820.dkr.ecr.us-west-2.amazonaws.com",

    OIDC_CLIENT_ID  = "5ajs8pq0gatbgpjejld96fldrn",
    OIDC_ISSUER_URL = "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_ajvPoziaS",

    RABBITMQ_PACK_VERSION = "8.15.2",

    string = "$${string}",

    ADDON_SPECTRO_REPO_URL = "https://addon-registry.gehc.spectrocloud.com",
  }

  projects_folder = "./config/project-2.0"
  projects_params = {}

  clusters_folder = "./config/cluster-2.0"
  clusters_params = {}

}

module "SpectroOrg" {
  source          = "../"
  //  source          = "github.com/spectrocloud/terraform-spectrocloud-modules"


  sc_host         = "stage.spectrocloud.com"   #e.g: api.spectrocloud.com (for SaaS)
  sc_username     = "rishi+soak@spectrocloud.com" #e.g: user1@abc.com
  sc_password     = "R1#rishi"         #e.g: supereSecure1!
  sc_project_name = "sanity testing"                    #e.g: Default

  /*accounts = tomap({
    for k, v in module.fetcher_accounts.object_files :
    k => yamldecode(templatefile(join("", [local.accounts_folder, "/${k}"]), local.accounts_params))
  })*/

  /*accounts = tomap({
    for k, v in toset([
      "config/account-2.0/account-aws-1.yaml",
      "config/account-2.0/account-aws-2.yaml",
    ]) :
    k => yamldecode(templatefile(join("", [local.accounts_folder, "/${k}"]), local.accounts_params))
  })

  bsls = tomap({
    for k, v in toset([
      "config/bsl-2.0/bsl-s3-1.yaml",
    ]) :
    k => yamldecode(templatefile(join("", [local.bsls_folder, "/${k}"]), local.bsl_params))
  })

  profiles = tomap({
    for k, v in toset([
      "profile-infra-EHS20RC1_Base_Infra_Org.yaml",
      "profile-addon-EHS20RC1_Pre-Reqs-Org.yaml",
    ]) :
    k => yamldecode(templatefile(join("", [local.profiles_folder, "/${k}"]), local.profile_params))
  })

  projects = tomap({
    for k, v in toset([
      "project-developer-abc.yaml",
      "project-developer-arun.yaml",
      "project-developer-def.yaml",
      "project-providence-004.yaml"
    ]) :
    k => yamldecode(templatefile(join("", [local.projects_folder, "/${k}"]), local.projects_params))
  })
*/

  clusters = tomap({
  for k, v in toset([
    "cluster-eks-test.yaml",
  ]) :
  k => yamldecode(file("/Users/rishi/work/git_clones/terraform-spectrocloud-modules/deploy/config/cluster-2.0/cluster-eks-demo.yaml"))
  })
}