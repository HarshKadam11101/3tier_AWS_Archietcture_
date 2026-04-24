resource "aws_lb" "this" {
  name               = "${var.env}-public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = var.public_subnet

  tags = {
    Name = "${var.env}-alb"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.env}-app-tg"
  vpc_id   = var.vpc_id
  port     = 80
  protocol = "HTTP"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}