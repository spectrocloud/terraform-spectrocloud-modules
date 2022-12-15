
locals {
  source_tier_properties_params = {
    base64_encode_password = base64encode("test123!wewe!")
  }
}

module "Spectro" {
  source = "../../"
  application_profiles = {
    for k in fileset("config/apps", "app-profile-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(templatefile("config/apps/${k}", local.source_tier_properties_params))
  }

}
