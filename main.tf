provider "aws" {
  region = "ap-southeast-2"
}

resource "random_id" "sg_suffix" {
  byte_length = 2
}

resource "aws_security_group" "web_sg" {
  name        = "ansible-web-sg-${random_id.sg_suffix.hex}"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0279a86684f669718" # Ubuntu 22.04 in Sydney
  instance_type = "t3.micro"
  key_name      = "devops-key"  # replace with your AWS key pair name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "AnsibleDemo"
  }
}

output "web_public_ip" {
  value = aws_instance.web.public_ip
}
