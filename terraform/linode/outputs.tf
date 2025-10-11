output "vpc_id" {
  value = linode_vpc.kube_vpc.id
}

output "subnet_id" {
  value = linode_vpc_subnet.kube_subnet.id
}
