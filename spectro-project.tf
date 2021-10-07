locals {
  project_ids = {
    for k, v in spectrocloud_project.project :
    v.name => v.id
  }
}

resource "spectrocloud_project" "project" {
  for_each = var.projects

  name        = each.value.name
  description = each.value.description
}
