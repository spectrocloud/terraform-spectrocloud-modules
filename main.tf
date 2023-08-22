terraform {
  required_providers {
    spectrocloud = {
      version = "~> 0.11.5"
      source  = "spectrocloud/spectrocloud"
    }
  }

  required_version = ">= 1.4.4"
}
