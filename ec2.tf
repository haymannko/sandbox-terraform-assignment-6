
resource "tls_private_key" "ssh_keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  filename = "${path.root}/private_key.pem"
  content = tls_private_key.ssh_keypair.private_key_pem
  
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name = "susu.pub"
  public_key = tls_private_key.ssh_keypair.public_key_openssh
  
}

resource "aws_security_group" "server-sg1" {
  vpc_id = aws_vpc.peering_vpc1.id
  name = "server-sg"
  tags = {
    Name = "Server-SG"
  } 
}

resource "aws_vpc_security_group_ingress_rule" "ingress_ssh_allow1" {
  security_group_id = aws_security_group.server-sg1.id
  cidr_ipv4         = local.any_where
  ip_protocol       = local.any_protocol
}


resource "aws_vpc_security_group_egress_rule" "egress_all_allow1" {
  security_group_id = aws_security_group.server-sg1.id
  cidr_ipv4         = local.any_where
  ip_protocol       = local.any_protocol # semantically equivalent to all ports
}

resource "aws_security_group" "server-sg2" {
  vpc_id = aws_vpc.peering_vpc2.id
  name = "server-sg2"
  tags = {
    Name = "Server-SG2"
  } 
}

resource "aws_vpc_security_group_ingress_rule" "ingress_ssh_allow2" {
  security_group_id = aws_security_group.server-sg2.id
  cidr_ipv4         = local.any_where
  ip_protocol       = local.any_protocol
}


resource "aws_vpc_security_group_egress_rule" "egress_all_allow2" {
  security_group_id = aws_security_group.server-sg2.id
  cidr_ipv4         = local.any_where
  ip_protocol       = local.any_protocol # semantically equivalent to all ports
}




resource "aws_instance" "public-server" {
  ami           = local.selected_ami
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.server-sg1.id ]
  key_name = aws_key_pair.ec2_key_pair.key_name
  subnet_id = aws_subnet.public-subnet1.id


  tags = {
    Name = "${local.vpc_name1}-Server-1"
  }
}

resource "aws_instance" "private-server" {
  ami           = local.selected_ami
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.server-sg2.id ]
  key_name = aws_key_pair.ec2_key_pair.key_name
  subnet_id = aws_subnet.private-subnet1.id


  tags = {
    Name = "${local.vpc_name2}-Server-2"
  }
}





variable "Operation_System" {
  description = "Choose your OS: [ \"ubuntu\" , \"amazon-linux-2\"]"
  type = string
  validation {
    condition = var.Operation_System == "ubuntu" || var.Operation_System == "amazon-linux-2"
    error_message = "Pauk ka ya ma yike par nae"

  }
  
}

locals {
  any_where = "0.0.0.0/0"
  any_protocol = "-1"
  os_to_ami = {
    "ubuntu" = "ami-06650ca7ed78ff6fa"
    "amazon-linux-2" = "ami-03a6b9092d0d03aab"
  }

  ssh_username = {
    "ami-06650ca7ed78ff6fa" = "ubuntu"
    "ami-03a6b9092d0d03aab" = "ec2-user"
  }

  selected_ami = lookup(local.os_to_ami,var.Operation_System, "whoami?")
}


resource "aws_eip" "public_eip" {
  domain = "vpc"
}

resource "aws_eip_association" "binding_server_eip" {
  instance_id = aws_instance.public-server.id
  allocation_id = aws_eip.public_eip.id
  
}




