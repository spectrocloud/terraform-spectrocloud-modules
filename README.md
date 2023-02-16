# Spectrocloud Terraform Modules. ####

Spectro Cloud module is a container for all Palette resources that are used together. 
You can use modules to create lightweight abstractions, using yaml files translated into Terraform.

# Module structure. ####
Create yaml files such as: ```cluster.yaml```, ```profile.yaml```, ```main.tf``` and others describing the cloud resources and module configuration. [More examples could be found here](https://github.com/spectrocloud/terraform-spectrocloud-modules/tree/main/examples).

### The list of Spectro Cloud module supported cloud types are:
* EKS
* AKS
* VMware 
* Edge

### Additional Spectro Cloud resources supported:
* cloud accounts for supported cloud types
* alerts
* cluster profiles
* addon deployments
* appliances
* backup storage locations
* registries
* projects
* teams
* macros
* application profiles
 
#### 1. Users can provision multiple resources from different modules and define and set as many parameters as required with unique names (duplicate names are not recommended).
<pre>
module "SpectroAcc" {

accounts = {
for k in fileset("config/account", "account-*.yaml") :
trimsuffix(k, ".yaml") => yamldecode(templatefile("config/account/${k}", local.accounts_params))
}
}

module "SpectroOrg" {

profiles = {
for k in fileset("config/profile", "profile-*.yaml") :
trimsuffix(k, ".yaml") => yamldecode(templatefile("config/profile/${k}", local.profile_params))
}
}

module "SpectroProject" {

clusters = {
for k in fileset("config/cluster", "cluster-*.yaml") :
trimsuffix(k, ".yaml") => yamldecode(templatefile("config/cluster/${k}", local.project_params))
}
</pre>

<pre>
1. Provision cloud accounts:<br>
   terraform apply -target module.SpectroAcc.spectrocloud_cloudaccount_aws.account

2. Provision profiles:<br>
   terraform apply -target module.SpectroOrg.spectrocloud_cluster_profile.profile_resource

3. Provision clusters:<br>
   terraform apply -target module.SpectroProject.spectrocloud_cluster_eks.this

4. Provision addon deployments:<br>
   terraform apply -target module.SpectroProject.spectrocloud_addon_deployment.this
</pre>

#### 2. Use reverse commands order to de-provision resources:
<pre>
1. terraform destroy -target module.SpectroProject.spectrocloud_addon_deployment.this
2. terraform destroy -target module.SpectroProject.spectrocloud_cluster_eks.this
3. terraform destroy -target module.SpectroOrg.spectrocloud_cluster_profile.profile_resource
4. terraform destroy -target module.SpectroAcc.spectrocloud_cloudaccount_aws.account
</pre>



# Module Resources & Requirements

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_spectrocloud"></a> [spectrocloud](#requirement\_spectrocloud) | ~> 0.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_spectrocloud"></a> [spectrocloud](#provider\_spectrocloud) | ~> 0.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [spectrocloud_addon_deployment.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/addon_deployment) | resource |
| [spectrocloud_alert.cluster_health_alerts](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/alert) | resource |
| [spectrocloud_appliance.appliance](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/appliance) | resource |
| [spectrocloud_application.app_deployment](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/application) | resource |
| [spectrocloud_application_profile.app_profile](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/application_profile) | resource |
| [spectrocloud_backup_storage_location.bsl](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/backup_storage_location) | resource |
| [spectrocloud_cloudaccount_aws.account](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cloudaccount_aws) | resource |
| [spectrocloud_cloudaccount_tencent.account](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cloudaccount_tencent) | resource |
| [spectrocloud_cluster_edge.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_edge) | resource |
| [spectrocloud_cluster_edge_vsphere.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_edge_vsphere) | resource |
| [spectrocloud_cluster_eks.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_eks) | resource |
| [spectrocloud_cluster_group.clustergroup](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_group) | resource |
| [spectrocloud_cluster_libvirt.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_libvirt) | resource |
| [spectrocloud_cluster_profile.profile_resource](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_profile) | resource |
| [spectrocloud_cluster_profile_import.import](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_profile_import) | resource |
| [spectrocloud_cluster_tke.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_tke) | resource |
| [spectrocloud_cluster_vsphere.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_vsphere) | resource |
| [spectrocloud_macro.macro](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/macro) | resource |
| [spectrocloud_project.project](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/project) | resource |
| [spectrocloud_registry_helm.helm_registry](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/registry_helm) | resource |
| [spectrocloud_registry_oci.oci_registry](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/registry_oci) | resource |
| [spectrocloud_team.project_team](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/team) | resource |
| [spectrocloud_virtual_cluster.virtual_cluster](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/virtual_cluster) | resource |
| [spectrocloud_appliance.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/appliance) | data source |
| [spectrocloud_application_profile.app_profile](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/application_profile) | data source |
| [spectrocloud_backup_storage_location.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/backup_storage_location) | data source |
| [spectrocloud_cloudaccount_aws.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/cloudaccount_aws) | data source |
| [spectrocloud_cloudaccount_tencent.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/cloudaccount_tencent) | data source |
| [spectrocloud_cloudaccount_vsphere.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/cloudaccount_vsphere) | data source |
| [spectrocloud_cluster.cluster_gps](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/cluster) | data source |
| [spectrocloud_cluster.clusters](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/cluster) | data source |
| [spectrocloud_cluster.deployment_cluster](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/cluster) | data source |
| [spectrocloud_cluster.host_cluster](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/cluster) | data source |
| [spectrocloud_cluster_group.cluster_group](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/cluster_group) | data source |
| [spectrocloud_cluster_group.vir_cluster_group](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/cluster_group) | data source |
| [spectrocloud_cluster_profile.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/cluster_profile) | data source |
| [spectrocloud_pack.data_packs](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/pack) | data source |
| [spectrocloud_pack_simple.app_source_tiers](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/pack_simple) | data source |
| [spectrocloud_registry.all_registries](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/registry) | data source |
| [spectrocloud_registry.app_registries](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/registry) | data source |
| [spectrocloud_role.data_roles](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accounts"></a> [accounts](#input\_accounts) | n/a | `map(any)` | `{}` | no |
| <a name="input_alerts"></a> [alerts](#input\_alerts) | n/a | `any` | `{}` | no |
| <a name="input_appliances"></a> [appliances](#input\_appliances) | n/a | `map(any)` | `{}` | no |
| <a name="input_application_deployments"></a> [application\_deployments](#input\_application\_deployments) | n/a | `any` | `{}` | no |
| <a name="input_application_profiles"></a> [application\_profiles](#input\_application\_profiles) | n/a | `any` | `{}` | no |
| <a name="input_bsls"></a> [bsls](#input\_bsls) | n/a | `map(any)` | `{}` | no |
| <a name="input_cluster_groups"></a> [cluster\_groups](#input\_cluster\_groups) | n/a | `any` | `{}` | no |
| <a name="input_cluster_profile_imports"></a> [cluster\_profile\_imports](#input\_cluster\_profile\_imports) | n/a | `list(string)` | `[]` | no |
| <a name="input_cluster_profile_imports_context"></a> [cluster\_profile\_imports\_context](#input\_cluster\_profile\_imports\_context) | n/a | `string` | `"project"` | no |
| <a name="input_clusters"></a> [clusters](#input\_clusters) | n/a | `map` | `{}` | no |
| <a name="input_macros"></a> [macros](#input\_macros) | n/a | `map(any)` | `{}` | no |
| <a name="input_profiles"></a> [profiles](#input\_profiles) | n/a | `map` | `{}` | no |
| <a name="input_projects"></a> [projects](#input\_projects) | n/a | `map(any)` | `{}` | no |
| <a name="input_registries"></a> [registries](#input\_registries) | n/a | `map(any)` | `{}` | no |
| <a name="input_teams"></a> [teams](#input\_teams) | n/a | `map(any)` | `{}` | no |
| <a name="input_virtual_clusters"></a> [virtual\_clusters](#input\_virtual\_clusters) | n/a | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_debug"></a> [debug](#output\_debug) | n/a |
| <a name="output_debug_addon_pack_manifests"></a> [debug\_addon\_pack\_manifests](#output\_debug\_addon\_pack\_manifests) | n/a |
| <a name="output_debug_aws_accounts"></a> [debug\_aws\_accounts](#output\_debug\_aws\_accounts) | n/a |
| <a name="output_debug_cluster_infra_profiles_map"></a> [debug\_cluster\_infra\_profiles\_map](#output\_debug\_cluster\_infra\_profiles\_map) | n/a |
| <a name="output_debug_cluster_profile_pack_map"></a> [debug\_cluster\_profile\_pack\_map](#output\_debug\_cluster\_profile\_pack\_map) | not addon specific |
| <a name="output_debug_cluster_system_profiles_map"></a> [debug\_cluster\_system\_profiles\_map](#output\_debug\_cluster\_system\_profiles\_map) | n/a |
| <a name="output_debug_libvirt_system"></a> [debug\_libvirt\_system](#output\_debug\_libvirt\_system) | n/a |
| <a name="output_debug_system_pack_manifests"></a> [debug\_system\_pack\_manifests](#output\_debug\_system\_pack\_manifests) | n/a |
