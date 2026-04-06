variable "ami_id" {
    description = "Ami Id For Ec2"
    type = string
    default = "ami-05d2d839d4f73aafb"
  
}

variable "instance_type" {
    description = "Instance type for Ec2"
    type = string
    default = "t3.micro"
  
}


variable "ssh_port" {
  type = number
  default = 22
}

variable "All_ports" {
  type = number
  default = 0     
}

variable "all_trafic_cidr" {
  type = list(string)
  default = ["0.0.0.0/0"]
  
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  type = string
  default = "10.0.1.0/24"
  
}

variable "public_subnet_2_cidr" {
  type = string
  default = "10.0.2.0/24"
}


variable "private_subnet_1_cidr" {
  type = string
  default = "10.0.3.0/24"
  
}

variable "private_subnet_2_cidr" {
  type = string
  default = "10.0.4.0/24"
  
}