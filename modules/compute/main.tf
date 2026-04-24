data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "app" {
  name          = "${var.env}-app-template"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.app_sg]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<h1>Hello from the App Tier - 3 Tier Arch</h1>" >> /var/www/html/index.html
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "${var.env}-private-app-server" }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  vpc_zone_identifier       = var.private_app_subnet
  target_group_arns         = [var.target_group]
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 2
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.env}-asg-instance"
    propagate_at_launch = true
  }
}