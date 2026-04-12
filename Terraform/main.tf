
############################ VPC ##############################

resource "aws_vpc" "Terraform-VPC" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Terraform-VPC"
  }
}

############################ SUBNETS ##############################

# Public
resource "aws_subnet" "Terraform-Public-Subnet-1" {
  vpc_id            = aws_vpc.Terraform-VPC.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Public-Subnet-1"
  }
}

resource "aws_subnet" "Terraform-Public-Subnet-2" {
  vpc_id            = aws_vpc.Terraform-VPC.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Public-Subnet-2"
  }
}

# Private
resource "aws_subnet" "Terraform-Private-Subnet-1" {
  vpc_id            = aws_vpc.Terraform-VPC.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Private-Subnet-1"
  }
}

resource "aws_subnet" "Terraform-Private-Subnet-2" {
  vpc_id            = aws_vpc.Terraform-VPC.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Private-Subnet-2"
  }
}

############################ INTERNET GATEWAY ##############################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Terraform-VPC.id

  tags = {
    Name = "IGW"
  }
}

############################ ROUTE TABLE (PUBLIC) ##############################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.Terraform-VPC.id

  route {
    cidr_block = var.all_trafic_cidr[0]
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-RT"
  }
}

resource "aws_route_table_association" "pub1" {
  subnet_id      = aws_subnet.Terraform-Public-Subnet-1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pub2" {
  subnet_id      = aws_subnet.Terraform-Public-Subnet-2.id
  route_table_id = aws_route_table.public_rt.id
}

############################ NAT ##############################
resource "aws_eip" "nat_eip" {
  domain = "vpc"
    tags = {
    Name = "NAT-EIP"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.Terraform-Public-Subnet-1.id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "NAT-Gateway"
  }
}

############################ PRIVATE ROUTE ##############################
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.Terraform-VPC.id

  route {
    cidr_block     = var.all_trafic_cidr[0]
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "Terraform-Private-Subnet-1" {
  subnet_id      = aws_subnet.Terraform-Private-Subnet-1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "Terraform-Private-Subnet-2" {
  subnet_id      = aws_subnet.Terraform-Private-Subnet-2.id
  route_table_id = aws_route_table.private_rt.id
}

############################ SECURITY GROUPS ##############################

# Public SG
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.Terraform-VPC.id

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = var.all_trafic_cidr
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.all_trafic_cidr
  }

  egress {
    from_port   = var.All_ports
    to_port     = var.All_ports
    protocol    = "-1"
    cidr_blocks = var.all_trafic_cidr
  }

    tags = {
    Name = "Public-SG"
  }
}


# Private SG
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.Terraform-VPC.id

  ingress {
    from_port       = var.ssh_port
    to_port         = var.ssh_port
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = var.All_ports
    to_port     = var.All_ports
    protocol    = "-1"
    cidr_blocks = var.all_trafic_cidr
  }

  tags = {
    Name = "Private-SG"
  }
}

############################ EC2 ##############################

# Frontend
resource "aws_instance" "frontend1" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.Terraform-Public-Subnet-1.id
  key_name                    = var.pem_key_name
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Frontend-1"
  }
}

resource "aws_instance" "frontend2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.Terraform-Public-Subnet-2.id
  key_name                    = var.pem_key_name
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Frontend-2"
  }
}

# Private EC2 (Example Train only, same pattern for Bus/Flight)
resource "aws_instance" "Train-1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.Terraform-Public-Subnet-1.id
  key_name               = var.pem_key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

tags = {
  Name = "Train-1"
 }
}
resource "aws_instance" "Train-2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.Terraform-Private-Subnet-2.id
  key_name               = var.pem_key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
  Name = "Train-2"
 }
}

resource "aws_instance" "Bus-1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.Terraform-Private-Subnet-1.id
  key_name               = var.pem_key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

tags = {
  Name = "Bus-1"
 }
}

resource "aws_instance" "Bus-2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.Terraform-Private-Subnet-2.id
  key_name               = var.pem_key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  tags = {
  Name = "Bus-2"
 }
}

resource "aws_instance" "Flight-1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.Terraform-Private-Subnet-1.id
  key_name               = var.pem_key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

tags = {
  Name = "Flight-1"
 }
}
resource "aws_instance" "Flight-2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.Terraform-Private-Subnet-2.id
  key_name               = var.pem_key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

tags = {
  Name = "Flight-2"
 }
}

##################### TARGET GROUP ###############

resource "aws_lb_target_group" "frontend_tg" {
  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Terraform-VPC.id

  health_check {
    path = "/"
    port = "80"
  }

  tags = {
    Name = "Frontend-TG"
  }
}

resource "aws_lb_target_group" "train_tg" {
  name     = "train-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Terraform-VPC.id

  health_check {
    path = "/train"
  }

  tags = {
    Name = "Train-TG"
  }
}

resource "aws_lb_target_group" "bus_tg" {
  name     = "bus-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Terraform-VPC.id

  health_check {
    path = "/bus"
  }

  tags = {
    Name = "Bus-TG"
  }
}

resource "aws_lb_target_group" "flight_tg" {
  name     = "flight-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Terraform-VPC.id

  health_check {
    path = "/flight"
  }

  tags = {
    Name = "Flight-TG"
  }
}

######################### TARGET ATTACHMENTS (EC2 connect) #############
resource "aws_lb_target_group_attachment" "Train-1" {
  target_group_arn = aws_lb_target_group.train_tg.arn
  target_id        = aws_instance.Train-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "Train-2" {
  target_group_arn = aws_lb_target_group.train_tg.arn
  target_id        = aws_instance.Train-2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "Bus-1" {
  target_group_arn = aws_lb_target_group.bus_tg.arn
  target_id        = aws_instance.Bus-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "Bus-2" {
  target_group_arn = aws_lb_target_group.bus_tg.arn
  target_id        = aws_instance.Bus-2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "Flight-1" {
  target_group_arn = aws_lb_target_group.flight_tg.arn
  target_id        = aws_instance.Flight-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "Flight-2" {
  target_group_arn = aws_lb_target_group.flight_tg.arn
  target_id        = aws_instance.Flight-2.id
  port             = 80
}


############################ ALB ##############################
resource "aws_lb" "Terraform-ALB" {
  name               = "project-alb"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.Terraform-Public-Subnet-1.id,
    aws_subnet.Terraform-Public-Subnet-2.id
  ]

  security_groups = [aws_security_group.public_sg.id]

  tags = {
    Name = "Terraform-ALB"
  }
}

################### LISTENER (DEFAULT → FRONTEND) ###############
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.Terraform-ALB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

################## PATH BASED ROUTING RULES ################

resource "aws_lb_listener_rule" "train_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.train_tg.arn
  }

  condition {
    path_pattern {
      values = ["/train*"]
    }
  }
}

resource "aws_lb_listener_rule" "bus_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bus_tg.arn
  }

  condition {
    path_pattern {
      values = ["/bus*"]
    }
  }
}


resource "aws_lb_listener_rule" "flight_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flight_tg.arn
  }

  condition {
    path_pattern {
      values = ["/flight*"]
    }
  }
}

