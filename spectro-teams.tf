data "spectrocloud_role" "data_roles" {
  for_each = toset(local.project_roles)

  name = each.value
}

output "test" {
  value = var.teams
}

output "test2" {
  value = data.spectrocloud_role.data_roles
}

locals {
  project_roles = distinct(flatten([
    for v in var.teams : [
      for t in v.teams : t.roles
  ]]))

  project_teams = distinct(flatten([
    for k, v in var.teams : [
      for t in v.teams : {
        project_name = v.name
        team_name    = t.name
        role_ids     = [for r in t.roles : data.spectrocloud_role.data_roles[r].id]
      }
    ]
  ]))
}

resource "spectrocloud_team" "project_team" {
  count = length(local.project_teams)

  name = local.project_teams[count.index].team_name
  project_role_mapping {
    id    = local.project_ids[local.project_teams[count.index].project_name]
    roles = local.project_teams[count.index].role_ids
  }
}
