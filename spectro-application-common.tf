locals{
  app_deployments = flatten([for app_dep in var.application_deployments: app_dep if can(app_dep)])
  app_profiles_name = flatten([for dep in local.app_deployments: dep.application_name if can(dep.application_name)])

  clusters_name = flatten([for a in local.app_deployments: a.config.cluster_name])
  clusters_group_name = flatten([for b in local.app_deployments: b.config.cluster_group_name])

  app_profiles_name_map = {
  for k, v in data.spectrocloud_application_profile.app_profile :
  v.name => v.id... if v.name != null
  }

  clusters_name_map = {
  for k, v in data.spectrocloud_cluster.deployment_cluster :
  v.name => v.id... if v.name != null
  }

  clusters_group_name_map = {
  for k, v in data.spectrocloud_cluster_group.cluster_group :
  v.name => v.id... if v.name != null
  }

  application_deployments = [for v in local.app_deployments :{
    name = format("%s",v.name)
    value = {
      name = v.name
      tags =  try(v.tags, [])
      application_name = try(v.application_name, "")
      config = try({
        cluster_name       = try(v.config.cluster_name, "")
        cluster_group_name = try(v.config.cluster_group_name, "")
        limits  = try(tolist([
          {
            name  = "limits"
            value = {
              cpu     = v.config.limits.cpu
              memory  = v.config.limits.memory
              storage = v.config.limits.storage
            }
          }]), [])
      }, {})
    }
  }]
  application_deployment_iterable = { for dep in toset(local.application_deployments): dep.name => dep.value }
}
data "spectrocloud_application_profile" "app_profile" {
  count = length(local.app_profiles_name)
  name = local.app_profiles_name[count.index]
}

data "spectrocloud_cluster" "deployment_cluster"{
  count = length(local.clusters_name)
  name = local.clusters_name[count.index]
}

data "spectrocloud_cluster_group" "cluster_group"{
  count = length(local.clusters_group_name)
  name = local.clusters_group_name[count.index]
}
