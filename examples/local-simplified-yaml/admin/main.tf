terraform {
  required_version = ">= 0.14.0"

  required_providers {
    spectrocloud = {
      version = "= 0.6.10-pre"
      source  = "spectrocloud/spectrocloud"
    }

    #    gitlab = {
    #      source  = "gitlabhq/gitlab"
    #      version = "3.6.0"
    #    }
  }
}

variable "sc_host" {}
variable "sc_api_key" {
  sensitive = true
}

provider "spectrocloud" {
  host         = var.sc_host
  api_key      = var.sc_api_key
  project_name = ""
}

#variable "gitlab_token" {}
#
#provider "gitlab" {
#  token = var.gitlab_token
#}

locals {
  projects = {
    for k in fileset("config/project", "project-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(file("config/project/${k}"))
  }

  profiles = {
    for k in fileset("config/profile", "profile-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(file("config/profile/${k}"))
  }
}

module "Spectro" {
  source = "github.com/spectrocloud/terraform-spectrocloud-modules"

  # It is recommended to use latest version of module instead of using latest from github
  #source  = "spectrocloud/modules/spectrocloud"
  #version = "0.0.7"

  projects = local.projects
  profiles = local.profiles
}
