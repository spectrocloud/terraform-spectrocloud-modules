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

