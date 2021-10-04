/*
data "spectrocloud_role" "projectadmin" {
  name = "Project Admin"
}

data "spectrocloud_role" "projectviewer" {
  name = "Project Viewer"
}

resource "spectrocloud_team" "projectadmin" {
  for_each = module.replacer_projects.all_objects

  name = format("%s_admin", each.value.name)
  project_role_mapping {
    id    = local.project_ids[each.value.name]
    roles = [data.spectrocloud_role.projectadmin.id]
  }
}

resource "spectrocloud_team" "projectview" {
  for_each = module.replacer_projects.all_objects

  name = format("%s_view", each.value.name)
  project_role_mapping {
    id    = local.project_ids[each.value.name]
    roles = [data.spectrocloud_role.projectviewer.id]
  }
}*/
