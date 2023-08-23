terraform {
  required_providers {
    spectrocloud = {
      version = "~> 0.11.8"
      source  = "spectrocloud/spectrocloud"
    }
  }

  required_version = ">= 1.4.4"
}
