#locals {
#  gitlab_project_ids = {
#  for k, v in gitlab_project.this :
#  v.name => v.id
#  }
#}
#
#resource "gitlab_project" "this" {
#  for_each = local.projects
#
#  name                   = each.value.name
#  description            = each.value.description
#  visibility_level       = "public" # or 'private'
#  pipelines_enabled      = true
#  shared_runners_enabled = true # shared runners means runners from different project can be used
#  import_url             = each.value.import_url
#}
#
#resource "gitlab_project_variable" "host" {
#  for_each = local.projects
#
#  project   = local.gitlab_project_ids[each.value.name]
#  key       = "SC_HOST_DEV"
#  value     = var.sc_host
#  protected = false
#}
#
#resource "gitlab_project_variable" "username" {
#  for_each = local.projects
#
#  project   = local.gitlab_project_ids[each.value.name]
#  key       = "SC_USERNAME_DEV"
#  value     = var.sc_username
#  protected = false
#}
#
#resource "gitlab_project_variable" "password" {
#  for_each = local.projects
#
#  project   = local.gitlab_project_ids[each.value.name]
#  key       = "SC_PASSWORD_DEV"
#  value     = var.sc_password
#  protected = false
#}
#
#resource "gitlab_project_variable" "project" {
#  for_each = local.projects
#
#  project   = local.gitlab_project_ids[each.value.name]
#  key       = "SC_PROJECT_DEV"
#  value     = each.value.name
#  protected = false
#}
#
#resource "gitlab_project_variable" "statekey" {
#  for_each = local.projects
#
#  project   = local.gitlab_project_ids[each.value.name]
#  key       = "PROJECT_TF_STATE"
#  value     = each.value.name
#  protected = false
#}