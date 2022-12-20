variable "accounts" {
  type    = map(any)
  default = {}
}

variable "appliances" {
  type    = map(any)
  default = {}
}

variable "bsls" {
  type    = map(any)
  default = {}
}

variable "profiles" {
  default = {}
}

variable "projects" {
  type    = map(any)
  default = {}
}

variable "teams" {
  type    = map(any)
  default = {}
}

variable "registries" {
  type    = map(any)
  default = {}
}

variable "clusters" {
  default = {}
}

variable "macros" {
  type    = map(any)
  default = {}
}

variable "application_profiles" {
  type    = any
  default = {}
}

variable "application_deployments" {
  type    = any
  default = {}
}

variable "virtual_clusters" {
  type    = any
  default = {}
}

variable "alerts" {
  type    = any
  default = {}
}
