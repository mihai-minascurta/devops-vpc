#Newest ubuntu version
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] 

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}


#Firewall
resource "aws_security_group" "andrei-sg" {
  name = "${var.project_name}"
  vpc_id = aws_vpc.andrei_vpc.id # Connect our VPC to the our firewall

  ingress {
    description = "Rules for HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Free exit"
    from_port = 0
    to_port = 0
    protocol= "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "andrei_server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public_subnet.id 
  vpc_security_group_ids =[aws_security_group.andrei-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              systemctl enable docker
              systemctl start docker
              docker run -d -p 80:80 nginx
              EOF
}

