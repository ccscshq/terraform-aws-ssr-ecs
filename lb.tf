resource "aws_lb" "this" {
  name               = "${var.prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.lb_delete_protection
}

resource "aws_lb_target_group" "this" {
  name        = "${var.prefix}-${var.ecs_container_port}"
  port        = var.ecs_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    interval            = 6
    path                = var.lb_healthcheck_path
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-204"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "listener_80" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type             = "forward"
  }

  depends_on = [aws_lb_target_group.this]
}
