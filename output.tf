output "k3s_nodes_public_ips" {
  value = {
    for idx, instance in aws_instance.k3s_nodes :
    format("k3s-node-%02d", idx + 1) => instance.public_ip
  }
}

output "k3s_nodes_private_ips" {
  value = {
    for idx, instance in aws_instance.k3s_nodes :
    format("k3s-node-%02d", idx + 1) => instance.private_ip
  }
}