variable "api_token" {
  description = "Linode API personal access token"
  type        = string
  sensitive   = true
}

variable "root_pass" {
  description = "Root password required by Linode when provisioning from an image"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Linode region for all resources"
  type        = string
  default     = "jp-osa"
}

variable "controller_type" {
  description = "Linode plan for controller nodes"
  type        = string
  default     = "g6-standard-2"
}

variable "worker_type" {
  description = "Linode plan for worker nodes"
  type        = string
  default     = "g6-standard-1"
}

variable "image" {
  description = "Base image for all nodes"
  type        = string
  default     = "linode/debian12"
}

variable "controller_instances" {
  description = "Suffix identifiers used when naming controller nodes"
  type        = set(string)
  default     = ["1", "2", "3"]
}

variable "worker_instances" {
  description = "Suffix identifiers used when naming worker nodes"
  type        = set(string)
  default     = ["1", "2", "3"]
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the Linode VPC subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "admin_user" {
  description = "Administrator account configured via cloud-init"
  type        = string
  default     = "kubespray"
}

variable "ssh_pubkey_path" {
  description = "Path to the SSH public key to authorize on the nodes"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "ssh_privatekey_path" {
  description = "Path to the SSH private key referenced by the generated inventory"
  type        = string
  default     = "~/.ssh/id_ed25519"
}

variable "base_tags" {
  description = "Tags applied to all Linode instances"
  type        = list(string)
  default     = ["kubespray"]
}

variable "backups_enabled" {
  description = "Enable automated Linode backups for all instances"
  type        = bool
  default     = false
}

variable "swap_size_mb" {
  description = "Swap disk size allocated to each instance in megabytes"
  type        = number
  default     = 512
}
