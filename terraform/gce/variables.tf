variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Resources Region"
  type        = string
  default     = "asia-east2"
}

variable "zone" {
  description = "GCP Resources Zone"
  type        = string
  default     = "asia-east2-b"
}

variable "admin_user" {
  type    = string
  default = "kubespray"
}

variable "ssh_pubkey_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "ssh_privatekey_path" {
  type    = string
  default = "~/.ssh/id_ed25519"
}
