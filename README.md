# Spectrocloud Terraform modules. ####

Spectrocloud modules project is a container for all spectrocloud resources that are used together. 
You can use modules to create lightweight abstractions, using yaml files which are translated into terraform.

# Module structure. ####
Create yaml files describing cloud resources and modules configuration ```cluster.yaml```, ```profile.yaml```,
```main.tf``` and others. Examples could be found here: 
[see examples](https://github.com/spectrocloud/terraform-spectrocloud-modules/tree/main/examples)
>   !NOTE!: Spectrocloud modules cloud types support list: EKS, AKS, VMware and Edge cloud types.
>
> Additional Spectrocloud resources supported:
> cloud accounts for supported cloud types, alerts, cluster profiles, addon deployments, appliances, backup storage locations, registries, projects, teams and macros.
> 
> 

#### 1. You can define and set as many parameters as you want as long as their names are unique. While provision multiple resources from different modules.
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





