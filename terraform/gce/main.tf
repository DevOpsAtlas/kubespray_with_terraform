terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2"
    }
  }

}

provider "google" {
  project = var.project_id
  region  = var.region
  # credentials = pathexpand("~/.config/gcloud/service-account.json")
}

# 1. Create VPC Network
resource "google_compute_network" "kube_net" {
  name                    = "kubespray-network"
  auto_create_subnetworks = false
}

# 2. Create Subnet
resource "google_compute_subnetwork" "kube_subnet" {
  name          = "kubespray-subnet"
  ip_cidr_range = "10.21.30.0/24"
  network       = google_compute_network.kube_net.id
}

# 3. Create Firewall
resource "google_compute_firewall" "kube_fw_allow_internal" {
  name    = "kubespray-firewall-allow-internal"
  network = google_compute_network.kube_net.id

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }

  source_ranges = [google_compute_subnetwork.kube_subnet.ip_cidr_range]
  target_tags   = ["kubespray"]
}

resource "google_compute_firewall" "kube_fw_allow_external" {
  name    = "kubespray-firewall-allow-external"
  network = google_compute_network.kube_net.id

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "6443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["kubespray"]
}

resource "google_compute_firewall" "kube_fw_allow_nodeports" {
  name    = "kubespray-firewall-allow-nodeports"
  network = google_compute_network.kube_net.id

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["kubespray", "worker"]
}

# 4. Create Controllers
module "kube_controllers" {
  source    = "./modules/vm_group"
  instances = ["1", "2", "3"]
  prefix    = "kube-controller"
  zone      = var.zone

  disk_size = 30

  machine_type = "e2-standard-4"
  tags         = ["kubespray", "controller"]
  network      = google_compute_network.kube_net.id
  subnetwork   = google_compute_subnetwork.kube_subnet.id
  metadata = {
    ssh-keys = "${var.admin_user}:${trimspace(file(pathexpand(var.ssh_pubkey_path)))}"
  }
}

# 5. Create Workers
module "kube_wokers" {
  source    = "./modules/vm_group"
  instances = ["1", "2", "3", "4"]
  prefix    = "kube-worker"
  zone      = var.zone

  disk_size = 50

  machine_type = "e2-standard-2"
  tags         = ["kubespray", "worker"]
  network      = google_compute_network.kube_net.id
  subnetwork   = google_compute_subnetwork.kube_subnet.id
  metadata = {
    ssh-keys = "${var.admin_user}:${trimspace(file(pathexpand(var.ssh_pubkey_path)))}"
  }
}

# 6. Dynamic inventory
locals {
  kube_control_plane_nodes = [
    for idx, inst in module.kube_controllers.instances : {
      name             = inst.name
      ansible_host     = inst.public_ip
      access_ip        = inst.private_ip
      etcd_member_name = "etcd${idx + 1}"
    }
  ]

  kube_worker_nodes = [
    for inst in module.kube_wokers.instances : {
      name         = inst.name
      ansible_host = inst.public_ip
      access_ip    = inst.private_ip
    }
  ]

  inventory_header = <<-EOT
    # This inventory describe a HA typology with stacked etcd (== same nodes as control plane)
    # and 3 worker nodes
    # See https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html
    # for tips on building your # inventory

    # Configure 'ip' variable to bind kubernetes services on a different ip than the default iface
    # We should set etcd_member_name for etcd cluster. The node that are not etcd members do not need to set the value,
    # or can set the empty string value.
  EOT

  kube_control_plane_block = join(
    "\n",
    concat(
      ["[kube_control_plane]"],
      [
        for node in local.kube_control_plane_nodes :
        "${node.name} ansible_host=${node.ansible_host} access_ip=${node.access_ip} etcd_member_name=${node.etcd_member_name}"
      ],
    ),
  )

  etcd_block = "[etcd:children]\nkube_control_plane"

  kube_node_block = join(
    "\n",
    concat(
      ["[kube_node]"],
      [
        for node in local.kube_worker_nodes :
        "${node.name} ansible_host=${node.ansible_host} access_ip=${node.access_ip}"
      ],
    ),
  )

  kube_all_vars_block = <<-EOT
    [all:vars]
    ansible_user=${var.admin_user}
    ansible_ssh_private_key_file=${var.ssh_privatekey_path}
  EOT

  inventory_content = format(
    "%s\n\n%s\n\n%s\n\n%s\n\n%s\n",
    trimspace(local.inventory_header),
    local.kube_control_plane_block,
    local.etcd_block,
    local.kube_node_block,
    local.kube_all_vars_block,
  )
}

resource "local_file" "kubespray_inventory" {
  filename        = "${path.root}/../../kubespray/inventory/fleet/inventory.ini"
  content         = local.inventory_content
  file_permission = "0644"
}
