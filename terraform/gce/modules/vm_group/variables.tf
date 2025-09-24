variable "instances" {
  description = "Set of identifiers used to create stable VM resources"
  type        = set(string)
}

variable "prefix" {
  type = string
}

variable "zone" {
  type = string
}

variable "disk_type" {
  type    = string
  default = "pd-ssd"
}

variable "boot_image" {
  type    = string
  default = "debian-cloud/debian-12"
}

variable "disk_size" {
  type = number
}

variable "machine_type" {
  type = string
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "metadata" {
  type    = map(string)
  default = {}
}
