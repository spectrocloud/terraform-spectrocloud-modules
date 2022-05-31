module "Spectro" {
  source = "../../"

  macros = {
    for k in fileset("config/macro", "macro-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(file("config/macro/${k}"))
  }

}
