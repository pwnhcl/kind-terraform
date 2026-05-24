variable "allowed_ports" {
  type    = list(number)
  default = [22, 80, 443, 81, 8000,8090, 8080, 2379, 2370, 2380, 6443, 10250, 8472, 51820, 51821, 5001, 6443, 30080, 30443, 9000]
}

variable "instance_count" {
  default = 3
}