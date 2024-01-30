module "Spectro" {
  source = "../../"

  macros_list = {
    for k in fileset("config/macros", "macro-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(file("config/macros/${k}"))
  }

}
