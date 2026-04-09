############################ vpc create ##############################
resource "aws_vpc" "Terraform-VPC" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Terraform-VPC"  
  
}
}

########################## Public Subnet create ##############################
resource "aws_subnet" "Terraform-Public-Subnet-1" {
  vpc_id            = aws_vpc.Terraform-VPC.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = "ap-south-1a"   
  tags = {
    Name = "Terraform-Public-Subnet-1"
  } 
}

resource "aws_subnet" "Terraform-Public-Subnet-2" {
  vpc_id = aws_vpc.Terraform-VPC.id
  cidr_block = var.public_subnet_2_cidr
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Terraform-Public-Subnet-2"
  }

}


############################# Private subnet create ##############################

resource "aws_subnet" "Terraform-Private-Subnet-1" {
  vpc_id            = aws_vpc.Terraform-VPC.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "ap-south-1a"   
  tags = {
    Name = "Terraform-Private-Subnet-1"
  } 
}

resource "aws_subnet" "Terraform-Private-Subnet-2" {
  vpc_id = aws_vpc.Terraform-VPC.id
  cidr_block = var.private_subnet_2_cidr
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Terraform-Private-Subnet-2"
  }

}

################################ Internet Gateway Create ##############################
resource "aws_internet_gateway" "Terraform-IGW" {
  vpc_id = aws_vpc.Terraform-VPC.id
  tags = {
    Name = "Terraform-IGW"
  }
}

############################## Public Route Table Create ##############################
resource "aws_route_table" "Terraform-RT-Public" {
  vpc_id = aws_vpc.Terraform-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Terraform-IGW.id
  }

  tags = {
    Name = "Terraform-RT-Public"
  }
}

resource "aws_route_table_association" "Public-Subnet-1-Association" {
  subnet_id      = aws_subnet.Terraform-Public-Subnet-1.id
  route_table_id = aws_route_table.Terraform-RT-Public.id
}

resource "aws_route_table_association" "Public-Subnet-2-Association" {
  subnet_id      = aws_subnet.Terraform-Public-Subnet-2.id
  route_table_id = aws_route_table.Terraform-RT-Public.id
}


####################################### Elastic IP Create For Nat Gateway ##############################
resource "aws_eip" "Terraform-EIP-Nat" {
  domain = "vpc"
  tags = {
    Name = "Terraform-EIP-Nat"
  }
}

##################################### Nat Gateway Create ##############################
resource "aws_nat_gateway" "Terraform-Nat-Gateway" {
  allocation_id = aws_eip.Terraform-EIP-Nat.id
  subnet_id     = aws_subnet.Terraform-Public-Subnet-1.id

  tags = {
    Name = "Terraform-Nat-Gateway"
  }
}


######################################## Private Route Table Create ##############################
resource "aws_route_table" "Terraform-RT-Private" {
  vpc_id = aws_vpc.Terraform-VPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Terraform-Nat-Gateway.id
  }

  tags = {
    Name = "Terraform-RT-Private"
  }
}


resource "aws_route_table_association" "Private-Subnet-1-Association" {
  subnet_id      = aws_subnet.Terraform-Private-Subnet-1.id
  route_table_id = aws_route_table.Terraform-RT-Private.id
}

resource "aws_route_table_association" "Private-Subnet-2-Association" {
  subnet_id      = aws_subnet.Terraform-Private-Subnet-2.id
  route_table_id = aws_route_table.Terraform-RT-Private.id
}


######################### Frontend EC2 create ##############################
resource "aws_instance" "Frontend-EC2-1" {
  ami           = var.ami_id
  instance_type = var.instance_type
  associate_public_ip_address = true
  subnet_id = aws_subnet.Terraform-Public-Subnet-1.id
  vpc_security_group_ids = [aws_security_group.Public-SG.id]
  tags = {
    Name = "Frontend-EC2"
  }
 
}

resource "aws_instance" "Frontend-EC2-2" {
  ami = var.ami_id
  instance_type = var.instance_type
  associate_public_ip_address = true
  subnet_id = aws_subnet.Terraform-Public-Subnet-2.id
  vpc_security_group_ids = [aws_security_group.Public-SG.id]
  
}

########################### Public Security Group  ##############################

resource "aws_security_group" "Public-SG" {
  name        = "public-sg"
  description = "Allow SSH and HTTP from internet"
  vpc_id      = aws_vpc.Terraform-VPC.id

  #### SSH access (login)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # 
  }

  #### HTTP (website)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #### Outbound (internet access)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public-SG"
  }
}

