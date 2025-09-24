output "public_ips" {
  description = "Public IP addresses for the VM instances"
  value = [
    for suffix in local.sorted_suffixes :
    google_compute_address.static_ips[suffix].address
  ]
}

output "private_ips" {
  description = "Private IP addresses for the VM instances"
  value = [
    for suffix in local.sorted_suffixes :
    google_compute_instance.vm_instances[suffix].network_interface[0].network_ip
  ]
}

output "instance_names" {
  description = "Names of the VM instances"
  value = [
    for suffix in local.sorted_suffixes :
    google_compute_instance.vm_instances[suffix].name
  ]
}

output "instances" {
  description = "Instance details keyed by suffix"
  value = [
    for suffix in local.sorted_suffixes :
    {
      suffix     = suffix
      name       = google_compute_instance.vm_instances[suffix].name
      public_ip  = google_compute_address.static_ips[suffix].address
      private_ip = google_compute_instance.vm_instances[suffix].network_interface[0].network_ip
    }
  ]
}
