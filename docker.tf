resource "aws_instance" "docker" {
    ami           = local.ami_id
    #instance_type = "t2.micro"
    instance_type = "t3.medium"
    vpc_security_group_ids = [aws_security_group.allow_all_docker.id]
    root_block_device {
      volume_size = 50
      volume_type = "gp3"
    }
    user_data = file("docker.sh")

    tags = {
        Name = "${var.project}-${var.environment}-docker-instance"
    } 
}

resource "aws_security_group" "allow_all_docker" {
    name        = "${var.project}-${var.environment}-docker-sg"
    description = "Allow all inbound and outtbound traffic for Docker instance"

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # All protocols
        cidr_blocks = ["0.0.0.0/0"] # Allow all inbound traffic
        ipv6_cidr_blocks = ["::/0"] # Allow all inbound traffic for IPv6
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # All protocols
        cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
        ipv6_cidr_blocks = ["::/0"] # Allow all outbound traffic for IPv6
    }

    lifecycle {
      create_before_destroy = true
    }

    tags = {
      Name = "${var.project}-${var.environment}-docker-sg"
    }
  
}