terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 3"
    }
  }
}

resource "linode_instance" "vm_instances" {
  for_each = var.instances

  label           = "${var.prefix}-vm-${each.key}"
  region          = var.region
  type            = var.instance_type
  image           = var.image
  tags            = var.tags
  private_ip      = var.private_ip
  authorized_keys = var.authorized_keys
  root_pass       = var.root_pass
  backups_enabled = var.backups_enabled
  swap_size       = var.swap_size

  metadata {
    user_data = var.user_data_base64
  }

  interface {
    purpose = "public"
  }

  interface {
    purpose   = "vpc"
    subnet_id = var.subnet_id
  }
}

locals {
  sorted_suffixes = sort(keys(linode_instance.vm_instances))
}
