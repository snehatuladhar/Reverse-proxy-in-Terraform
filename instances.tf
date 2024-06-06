resource "aws_security_group" "SG-Public" {
  name        = "SG-Public"
  description = "SG for the Public Instance"
  vpc_id      = aws_vpc.vpc-sn.id
  tags = {
    Name = "SG-Public"
  }
  ingress {
    description = "Allow HTTP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  ingress {
    description = "Allow HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  egress {
    description = "Outbound Rules to Allow All Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "s-Private" {
  name        = "s-Private"
  description = "SG for Private Instance"
  vpc_id      = aws_vpc.vpc-sn.id
  tags = {
    Name = "s-Private"
  }

  ingress {
    description = "Allow HTTP from the public instance"
    cidr_blocks = [aws_subnet.subnets["public-subnet-1a"].cidr_block]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  ingress {
    description = "Allow request on Port 3000 from public instance"
    cidr_blocks = [aws_subnet.subnets["public-subnet-1a"].cidr_block]
    from_port   = 3000
    protocol    = "tcp"
    to_port     = 3000
  }
  egress {
    description = "Outbound Rules to Allow All Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_iam_instance_profile" "IAM-Role" {
  name = "sneha-iam"
}

resource "aws_instance" "public-instance" {
  ami                         = "ami-00beae93a2d981137"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnets["public-subnet-1a"].id
  security_groups             = [aws_security_group.SG-Public.id]
  iam_instance_profile        = data.aws_iam_instance_profile.IAM-Role.name
  associate_public_ip_address = "true"
  tags = {
    Name      = "Public-EC2"
    owner     = var.owner_tag
    project   = "ec2-creation"
    silo      = "intern"
    terraform = "true"
  }
  user_data = base64encode("${templatefile("userdata/public.sh", {
    PRIVATE_SERVER_IP = aws_instance.private-instance.private_ip
  })}")

  # user_data = file("userdata/public.sh")
}

resource "aws_instance" "private-instance" {
  ami                         = "ami-00beae93a2d981137"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnets["private-subnet-1a"].id
  associate_public_ip_address = "false"
  security_groups             = [aws_security_group.s-Private.id]

  tags = {
    Name      = "sneha-private"
    owner     = var.owner_tag
    project   = "ec2-creation"
    silo      = "intern"
    terraform = "true"
  }
  user_data = file("userdata/priv.sh")
}
