resource "aws_lb" "alb-main" {
  name               = var.alb-name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb-sg-id]
  subnets            =  var.subnet-ids

  tags = {
    Name = "${var.alb-name}-${var.env-name}"
  }
}

resource "aws_lb_target_group" "tg-main" {
  name     = "${var.alb-name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  health_check {
    path="/"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = 200
  }
}


resource "aws_lb_target_group_attachment" "tga-main" {

  for_each = toset(var.isntance-ids)

  target_group_arn = aws_lb_target_group.tg-main.arn
  target_id        = each.value
  port             = 80
}

resource "aws_lb_listener" "listener-main" {
  load_balancer_arn = aws_lb.alb-main.arn

  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg-main.arn
  }
}