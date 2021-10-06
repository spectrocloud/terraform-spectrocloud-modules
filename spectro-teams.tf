data "spectrocloud_role" "roles" {
  for_each = var.teams

  name = each.key
}

locals {
  project_teams = distinct(flatten([
  for k, v in var.teams : [
  for project in var.projects : {
    project_name = project.name
    team_name   = format(v, project.name)
    role_id = data.spectrocloud_role.roles[k].id
  }
  ]
  ]))
}

resource "spectrocloud_team" "project_team" {
  count = length(local.project_teams)

  name = local.project_teams[count.index].team_name
  project_role_mapping {
    id    = local.project_ids[local.project_teams[count.index].project_name]
    roles = [local.project_teams[count.index].role_id]
  }
}
