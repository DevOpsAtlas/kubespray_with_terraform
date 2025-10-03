output "public_ips" {
  description = "Public IPv4 addresses for the instances"
  value = [
    for suffix in local.sorted_suffixes :
    linode_instance.vm_instances[suffix].ip_address
  ]
}

output "private_ips" {
  description = "Private IPv4 addresses for the instances"
  value = [
    for suffix in local.sorted_suffixes :
    one([for i in linode_instance.vm_instances[suffix].interface : i.ipv4[0].vpc if i.purpose == "vpc"])
  ]
}

output "instance_labels" {
  description = "Labels assigned to each instance"
  value = [
    for suffix in local.sorted_suffixes :
    linode_instance.vm_instances[suffix].label
  ]
}

output "instance_ids" {
  description = "Numeric Linode IDs for the instances"
  value = [
    for suffix in local.sorted_suffixes :
    linode_instance.vm_instances[suffix].id
  ]
}

output "instances" {
  description = "Instance details keyed by suffix"
  value = [
    for suffix in local.sorted_suffixes :
    {
      suffix     = suffix
      label      = linode_instance.vm_instances[suffix].label
      id         = linode_instance.vm_instances[suffix].id
      public_ip  = linode_instance.vm_instances[suffix].ip_address
      private_ip = one([for i in linode_instance.vm_instances[suffix].interface : i.ipv4[0].vpc if i.purpose == "vpc"])

    }
  ]
}
