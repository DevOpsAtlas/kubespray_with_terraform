variable "instances" {
  description = "Set of identifiers used to create stable Linode resources"
  type        = set(string)
}

variable "prefix" {
  description = "Prefix used for Linode instance labels"
  type        = string
}

variable "region" {
  description = "Linode region where instances are created"
  type        = string
}

variable "instance_type" {
  description = "Linode compute plan type (e.g., g6-standard-2)"
  type        = string
}

variable "image" {
  description = "Image to use for the instance boot disk"
  type        = string
}

variable "tags" {
  description = "Tags to assign to the instances"
  type        = list(string)
  default     = []
}

variable "subnet_id" {
  description = "Linode VPC subnet ID"
  type        = number
}

variable "private_ip" {
  description = "Whether to allocate a private IP for each instance"
  type        = bool
  default     = true
}

variable "authorized_keys" {
  description = "Public SSH keys to authorize on the instances"
  type        = list(string)
}

variable "root_pass" {
  description = "Root password required by Linode when creating from an image"
  type        = string
  sensitive   = true
}

variable "user_data_base64" {
  description = "Base64-encoded cloud-init user data"
  type        = string
}

variable "backups_enabled" {
  description = "Whether to enable Linode backups"
  type        = bool
  default     = false
}

variable "swap_size" {
  description = "Size of the swap disk in MB"
  type        = number
  default     = 512
}
