variable "ami_id" {}
variable "instance_type" {}

variable "ssh_port" {}
variable "All_ports" {}

variable "all_trafic_cidr" {
  type = list(string)
}

variable "vpc_cidr" {}

variable "public_subnet_1_cidr" {}
variable "public_subnet_2_cidr" {}

variable "private_subnet_1_cidr" {}
variable "private_subnet_2_cidr" {}

variable "pem_key_name" {}