locals {
  accounts_params = {
    TEST_PARAM_ADDON_VALUE = "String value replaced!",
    ADDON_MANIFEST_BOOLEAN_VALUE = true,
  }
}

module "SpectroProject" {
  source  = "spectrocloud/modules/spectrocloud"
  version = "~> 0.4.0"

  clusters = {
    for k in fileset("config/cluster", "cluster-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(templatefile("config/cluster/${k}", local.accounts_params))
  }
}
