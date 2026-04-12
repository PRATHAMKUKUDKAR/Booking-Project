########################### FRONTEND EC2 ##############################

output "frontend1_public_ip" {
  value = aws_instance.frontend1.public_ip
}

output "frontend1_private_ip" {
  value = aws_instance.frontend1.private_ip
}

output "frontend2_public_ip" {
  value = aws_instance.frontend2.public_ip
}

output "frontend2_private_ip" {
  value = aws_instance.frontend2.private_ip
}

########################### PRIVATE EC2 ##############################

output "train_1_private_ip" {
  value = aws_instance.Train-1.private_ip
}

output "train_2_private_ip" {
  value = aws_instance.Train-1.private_ip
}

output "bus_1_private_ip" {
  value = aws_instance.Bus-1.public_ip
}

output "bus_2_private_ip" {
  value = aws_instance.Bus-2.private_ip
}

output "flight_1_private_ip" {
  value = aws_instance.Flight-1.private_ip

}
output "flight_2_private_ip" {
  value = aws_instance.Flight-2.public_ip
}

########################### VPC ##############################

output "vpc_id" {
  value = aws_vpc.Terraform-VPC
}

output "vpc_cidr" {
  value = aws_vpc.Terraform-VPC
}

########################### SUBNETS ##############################

output "public_subnet_1_id" {
  value = aws_subnet.Terraform-Public-Subnet-1
}

output "public_subnet_2_id" {
  value = aws_subnet.Terraform-Public-Subnet-2
}

output "private_subnet_1_id" {
  value = aws_subnet.Terraform-Private-Subnet-1
}

output "private_subnet_2_id" {
  value = aws_subnet.Terraform-Private-Subnet-2
}

########################### ROUTE TABLE ##############################

output "public_route_table_id" {
  value = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  value = aws_route_table.private_rt.id
}

########################### INTERNET + NAT ##############################

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}

output "nat_public_ip" {
  value = aws_eip.nat_eip.public_ip
}

########################### SECURITY GROUP ##############################

output "public_sg_id" {
  value = aws_security_group.public_sg.id
}

output "private_sg_id" {
  value = aws_security_group.private_sg.id
}

########################### ALB ##############################

output "alb_dns_name" {
  value = aws_lb.Terraform-ALB
}

output "alb_arn" {
  value = aws_lb.Terraform-ALB
}

########################### TARGET GROUP ##############################

output "frontend_tg_arn" {
  value = aws_lb_target_group.frontend_tg
}

output "train_tg_arn" {
  value = aws_lb_target_group.train_tg
}

output "bus_tg_arn" {
  value = aws_lb_target_group.bus_tg
}
output "flight_tg_arn" {
  value = aws_lb_target_group.flight_tg
}
########################### KEY ##############################

output "key_pair_name" {
  value = var.pem_key_name
}