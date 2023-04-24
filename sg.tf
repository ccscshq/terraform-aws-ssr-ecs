resource "aws_security_group" "ecs" {
  name        = "${var.prefix}-ssr-ecs-sg"
  description = "SSR ECS"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.prefix}-ssr-ecs-sg"
  }
}

resource "aws_security_group_rule" "ecs_ingress" {
  security_group_id        = aws_security_group.ecs.id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "ecs_egress" {
  security_group_id = aws_security_group.ecs.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "alb" {
  name        = "${var.prefix}-ssr-alb-sg"
  description = "SSR ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.prefix}-ssr-alb-sg"
  }
}

resource "aws_security_group_rule" "alb_ingress" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.cloudfront.id]
}

resource "aws_security_group_rule" "alb_egress" {
  security_group_id = aws_security_group.alb.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
