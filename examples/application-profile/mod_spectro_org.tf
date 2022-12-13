module "Spectro" {
  source = "../../"

  application_profiles = {
    for k in fileset("config/apps", "app-profile-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(file("config/apps/${k}"))
  }

}
