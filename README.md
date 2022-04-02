<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_spectrocloud"></a> [spectrocloud](#requirement\_spectrocloud) | =0.6.6-pre |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_spectrocloud"></a> [spectrocloud](#provider\_spectrocloud) | 0.5.18 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [spectrocloud_appliance.appliance](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/resources/appliance) | resource |
| [spectrocloud_backup_storage_location.bsl](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/resources/backup_storage_location) | resource |
| [spectrocloud_cloudaccount_aws.account](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/resources/cloudaccount_aws) | resource |
| [spectrocloud_cloudaccount_tencent.account](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/resources/cloudaccount_tencent) | resource |
| [spectrocloud_cluster_edge.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/resources/cluster_edge) | resource |
| [spectrocloud_cluster_edge_vsphere.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/resources/cluster_edge_vsphere) | resource |
| [spectrocloud_cluster_eks.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/resources/cluster_eks) | resource |
| [spectrocloud_cluster_libvirt.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/resources/cluster_libvirt) | resource |
| [spectrocloud_cluster_profile.profile_resource](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/resources/cluster_profile) | resource |
| [spectrocloud_cluster_tke.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/resources/cluster_tke) | resource |
| [spectrocloud_project.project](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/resources/project) | resource |
| [spectrocloud_registry_helm.helm_registry](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/resources/registry_helm) | resource |
| [spectrocloud_registry_oci.oci_registry](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/resources/registry_oci) | resource |
| [spectrocloud_team.project_team](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/resources/team) | resource |
| [spectrocloud_appliance.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/data-sources/appliance) | data source |
| [spectrocloud_backup_storage_location.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/data-sources/backup_storage_location) | data source |
| [spectrocloud_cloudaccount_aws.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/data-sources/cloudaccount_aws) | data source |
| [spectrocloud_cloudaccount_tencent.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/data-sources/cloudaccount_tencent) | data source |
| [spectrocloud_cluster_profile.this](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/data-sources/cluster_profile) | data source |
| [spectrocloud_pack.data_packs](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/data-sources/pack) | data source |
| [spectrocloud_registry_helm.registry_helm](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/data-sources/registry_helm) | data source |
| [spectrocloud_registry_pack.registry_pack](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/data-sources/registry_pack) | data source |
| [spectrocloud_role.data_roles](https://registry.terraform.io/providers/spectrocloud/spectrocloud/0.6.6-pre/docs/data-sources/role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accounts"></a> [accounts](#input\_accounts) | n/a | `map(any)` | `{}` | no |
| <a name="input_appliances"></a> [appliances](#input\_appliances) | n/a | `map(any)` | `{}` | no |
| <a name="input_bsls"></a> [bsls](#input\_bsls) | n/a | `map(any)` | `{}` | no |
| <a name="input_clusters"></a> [clusters](#input\_clusters) | n/a | `map` | `{}` | no |
| <a name="input_profiles"></a> [profiles](#input\_profiles) | n/a | `map` | `{}` | no |
| <a name="input_projects"></a> [projects](#input\_projects) | n/a | `map(any)` | `{}` | no |
| <a name="input_registries"></a> [registries](#input\_registries) | n/a | `map(any)` | `{}` | no |
| <a name="input_teams"></a> [teams](#input\_teams) | n/a | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_appliance_uids"></a> [cluster\_appliance\_uids](#output\_cluster\_appliance\_uids) | n/a |
<!-- END_TF_DOCS -->