## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_spectrocloud"></a> [spectrocloud](#requirement\_spectrocloud) | ~> 0.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_spectrocloud"></a> [spectrocloud](#provider\_spectrocloud) | 0.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [spectrocloud_addon_deployment.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/addon_deployment) | resource |
| [spectrocloud_appliance.appliance](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/appliance) | resource |
| [spectrocloud_backup_storage_location.bsl](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/backup_storage_location) | resource |
| [spectrocloud_cloudaccount_aws.account](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cloudaccount_aws) | resource |
| [spectrocloud_cloudaccount_tencent.account](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cloudaccount_tencent) | resource |
| [spectrocloud_cluster_edge.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_edge) | resource |
| [spectrocloud_cluster_edge_vsphere.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_edge_vsphere) | resource |
| [spectrocloud_cluster_eks.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_eks) | resource |
| [spectrocloud_cluster_libvirt.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_libvirt) | resource |
| [spectrocloud_cluster_profile.profile_resource](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_profile) | resource |
| [spectrocloud_cluster_tke.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_tke) | resource |
| [spectrocloud_cluster_vsphere.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/cluster_vsphere) | resource |
| [spectrocloud_macro.macro](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/macro) | resource |
| [spectrocloud_project.project](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/project) | resource |
| [spectrocloud_registry_helm.helm_registry](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/registry_helm) | resource |
| [spectrocloud_registry_oci.oci_registry](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/registry_oci) | resource |
| [spectrocloud_team.project_team](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/resources/team) | resource |
| [spectrocloud_appliance.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/appliance) | data source |
| [spectrocloud_backup_storage_location.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/backup_storage_location) | data source |
| [spectrocloud_cloudaccount_aws.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/cloudaccount_aws) | data source |
| [spectrocloud_cloudaccount_tencent.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/cloudaccount_tencent) | data source |
| [spectrocloud_cloudaccount_vsphere.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/cloudaccount_vsphere) | data source |
| [spectrocloud_cluster.clusters](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/cluster) | data source |
| [spectrocloud_cluster_profile.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/cluster_profile) | data source |
| [spectrocloud_pack.data_packs](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/pack) | data source |
| [spectrocloud_registry.all_registries](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/registry) | data source |
| [spectrocloud_role.data_roles](https://registry.terraform.io/providers/spectrocloud/spectrocloud/latest/docs/data-sources/role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accounts"></a> [accounts](#input\_accounts) | n/a | `map(any)` | `{}` | no |
| <a name="input_alerts"></a> [alerts](#input\_alerts) | n/a | `map(any)` | `{}` | no |
| <a name="input_appliances"></a> [appliances](#input\_appliances) | n/a | `map(any)` | `{}` | no |
| <a name="input_bsls"></a> [bsls](#input\_bsls) | n/a | `map(any)` | `{}` | no |
| <a name="input_clusters"></a> [clusters](#input\_clusters) | n/a | `map` | `{}` | no |
| <a name="input_macros"></a> [macros](#input\_macros) | n/a | `map(any)` | `{}` | no |
| <a name="input_profiles"></a> [profiles](#input\_profiles) | n/a | `map` | `{}` | no |
| <a name="input_projects"></a> [projects](#input\_projects) | n/a | `map(any)` | `{}` | no |
| <a name="input_registries"></a> [registries](#input\_registries) | n/a | `map(any)` | `{}` | no |
| <a name="input_teams"></a> [teams](#input\_teams) | n/a | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_debug"></a> [debug](#output\_debug) | n/a |
| <a name="output_debug_addon_pack_manifests"></a> [debug\_addon\_pack\_manifests](#output\_debug\_addon\_pack\_manifests) | n/a |
| <a name="output_debug_aws_accounts"></a> [debug\_aws\_accounts](#output\_debug\_aws\_accounts) | n/a |
| <a name="output_debug_cluster_infra_profiles_map"></a> [debug\_cluster\_infra\_profiles\_map](#output\_debug\_cluster\_infra\_profiles\_map) | n/a |
| <a name="output_debug_cluster_system_profiles_map"></a> [debug\_cluster\_system\_profiles\_map](#output\_debug\_cluster\_system\_profiles\_map) | n/a |
| <a name="output_debug_libvirt_system"></a> [debug\_libvirt\_system](#output\_debug\_libvirt\_system) | n/a |
| <a name="output_debug_system_pack_manifests"></a> [debug\_system\_pack\_manifests](#output\_debug\_system\_pack\_manifests) | n/a |
