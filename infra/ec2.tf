resource "aws_security_group" "backend_server" {
  #checkov:skip=CKV_AWS_24:Enable ssh access from all sources since we don't have access to private GH Actions runners
  vpc_id = aws_vpc.main.id
  
  egress {
    description = "Allow egress from all sources on all ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ingress from all sources on port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ingress within private subnets on VPC on default port 5432"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ingress within private subnets on VPC on backend API listener port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH ingress for GitHub access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"] # canonical
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "backend_server" {
  #checkov:skip=CKV_AWS_88:Allow public IP for ssh access deploy since we don't have access to private GH Actions runners
  depends_on = [aws_route_table.main]
  instance_type = "t3.micro"
  ami = data.aws_ami.ubuntu.id

  tags = var.aws_tags
}