terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

locals {
  http_port = 8080
  any_port = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
}

resource "aws_launch_configuration" "example" {
  image_id = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance.id]

#Render user data script as template
user_data = templatefile("${path.module}/user-data.sh", {
  server_port = var.server_port
  db_address = "TEST"
  db_port = "TEST2"
})

# Requird when using launch configuration with an auto scaling group
  lifecycle {
    create_before_destroy = true
}

/*  user_data = <<-EOF
    #!bin/bash
    echo "Hello, World" > index.html
    nohup busybox httpd -f -p ${var.server_port} &
    EOF

    # Requird when using launch configuration with an auto scaling group
    lifecycle {
      create_before_destroy = true
    }
*/
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = data.aws_subnets.default.ids

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-tasg-ex"
    propagate_at_launch = true
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }  

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_lb" "example" {
  name = "${var.cluster_name}-tasg-ex"
  load_balancer_type = "application"
  subnets = data.aws_subnets.default.ids
  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port = local.http_port
  protocol = "HTTP"
  #By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404:page not found"
      status_code = 404
    }
  }
}

resource "aws_security_group" "alb" {
  name = "${var.cluster_name}-alb"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.alb.id
  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type = "egress"
  security_group_id = aws_security_group.alb.id
  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}


resource "aws_lb_target_group" "asg" {
  name = "${var.cluster_name}-tasg-ex"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id
  
  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

/*terraform {
  backend "s3" {}
}
*/