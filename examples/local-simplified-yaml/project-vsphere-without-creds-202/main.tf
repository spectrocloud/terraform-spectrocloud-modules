terraform {
  required_version = ">= 0.14.0"

  required_providers {
    spectrocloud = {
      version = "= 0.6.10-pre"
      source  = "spectrocloud/spectrocloud"
    }
  }
}

variable "sc_host" {}
variable "sc_api_key" {
  sensitive   = true
}
variable "sc_project_name" {}

provider "spectrocloud" {
  host         = var.sc_host
  api_key      = var.sc_api_key
  project_name = var.sc_project_name
}

locals {
  profiles = {
  for k in fileset("config/profile", "profile-*.yaml") :
  trimsuffix(k, ".yaml") => yamldecode(file("config/profile/${k}"))
  }

  appliances = {
  for k in fileset("config/appliance", "appliance-*.yaml") :
  trimsuffix(k, ".yaml") => yamldecode(file("config/appliance/${k}"))
  }

  clusters = {
  for k in fileset("config/cluster", "cluster-*.yaml") :
  trimsuffix(k, ".yaml") => yamldecode(file("config/cluster/${k}"))
  }
}

module "SpectroSystemProfile" {
  source = "github.com/spectrocloud/terraform-spectrocloud-modules"

  # It is recommended to use latest version of module instead of using latest from github
  #source  = "spectrocloud/modules/spectrocloud"
  #version = "0.0.7"

  profiles   = local.profiles
}

module "SpectroAppliance" {
  depends_on = [module.SpectroSystemProfile]
  source = "github.com/spectrocloud/terraform-spectrocloud-modules"

  # It is recommended to use latest version of module instead of using latest from github
  #source  = "spectrocloud/modules/spectrocloud"
  #version = "0.0.7"

  appliances = local.appliances
}

module "SpectroCluster" {
  depends_on = [module.SpectroAppliance]
  source = "github.com/spectrocloud/terraform-spectrocloud-modules"
  //source     = "/Users/rishi/work/git_clones/terraform-spectrocloud-modules"

  # It is recommended to use latest version of module instead of using latest from github
  #source  = "spectrocloud/modules/spectrocloud"
  #version = "0.0.7"

  clusters = local.clusters
}
