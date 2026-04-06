
########################### FrontEnd EC2 1 #######################################
output "Create_public_ip_Frontend_EC2_1" {
    description = "public id for Front-end-Ec2-1"
    value = aws_instance.Frontend-EC2-1
  
}

output "Create_private_ip_Frontend_EC2_1" {
    description = "Private ip for ec2"
    value = aws_instance.Frontend-EC2-1
  
}

output "Create_instance_type_Frontend_EC2_1" {
    description = "Instance Type"
    value = aws_instance.Frontend-EC2-1
  
}

output "Create_Instance_Name_Frontend_EC2_1" {
    description = "Instance neme"
    value = aws_instance.Frontend-EC2-1
  
}

################################## FrontEnd EC2 2 ##################################

output "Create_public_ip_Frontent_EC2_2" {
    description = "public id for Front-end-Ec2-2"
    value = aws_instance.Frontend-EC2-2
  
}

output "Create_private_ip_Frontend_EC2_2" {
    description = "Private ip for ec2"
    value = aws_instance.Frontend-EC2-2
  
}

output "Create_instance_type_Frontend_EC2_2" {
    description = "Instance Type"
    value = aws_instance.Frontend-EC2-2
  
}

output "Instance_Name_Frontend_EC2_2" {
    description = "Instance neme"
    value = aws_instance.Frontend-EC2-2
  
}

##################################### Security Group ############################



output "Create_security_group_id" {
  value = aws_security_group.Public-SG.id
}



output "Create_Public_sub_1" {
 value = aws_subnet.Terraform-Public-Subnet-1 
}

output "Create_Public_sub_2" {
  value = aws_subnet.Terraform-Public-Subnet-2
}   

output "Create_Private_sub_1" {
  value = aws_subnet.Terraform-Private-Subnet-1
}

output "Create_Private_sub_2" {
  value = aws_subnet.Terraform-Private-Subnet-2
}

output "Public_Route_Table_id" {
  value = aws_route_table.Terraform-RT-Public.id
}

output "Subnet_Assosiate_in_Public_Route_Table" {
  value = [
    aws_subnet.Terraform-Public-Subnet-1.id
  ,
    aws_subnet.Terraform-Public-Subnet-2.id
  ]
}

output "nat_eip_id" {
  description = "Elastic IP ID"
  value       = aws_eip.Terraform-EIP-Nat.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.Terraform-Nat-Gateway.id
}

output "nat_public_ip" {
  description = "Public IP of NAT Gateway"
  value       = aws_eip.Terraform-EIP-Nat.public_ip
}

output "Subnet_Assosiate_in_Private_Route_Table" {
  value = [
    aws_subnet.Terraform-Private-Subnet-1.id
  ,
    aws_subnet.Terraform-Private-Subnet-2.id
  ]
}