terraform {
  required_providers {
    spectrocloud = {
      version = "~> 0.17.2"
      source  = "spectrocloud/spectrocloud"
    }
  }

  required_version = ">= 1.4.4"
}
