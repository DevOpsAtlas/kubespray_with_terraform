terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7"
    }
  }
}

# 1. Create Static Public IP
resource "google_compute_address" "static_ips" {
  for_each = var.instances

  name         = "${var.prefix}-ip-${each.key}"
  address_type = "EXTERNAL"
}

# 2. Create Boot Disk
resource "google_compute_disk" "boot_disks" {
  for_each = var.instances

  name  = "${var.prefix}-boot-disk-${each.key}"
  type  = var.disk_type
  zone  = var.zone
  image = var.boot_image
  size  = var.disk_size
}

# 3. Create GCE Instance
resource "google_compute_instance" "vm_instances" {
  for_each = var.instances

  name         = "${var.prefix}-vm-${each.key}"
  machine_type = var.machine_type
  zone         = var.zone

  tags = var.tags

  boot_disk {
    auto_delete = false
    source      = google_compute_disk.boot_disks[each.key].self_link
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    access_config {
      nat_ip = google_compute_address.static_ips[each.key].address
    }
  }

  metadata = var.metadata

  can_ip_forward = true
}

locals {
  sorted_suffixes = sort(keys(google_compute_instance.vm_instances))
}
