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
* macros.
 
#### 1. YUsers can provision multiple resources from different modules and define and set as many parameters as required with unique names (duplicate names are not recommended).
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





