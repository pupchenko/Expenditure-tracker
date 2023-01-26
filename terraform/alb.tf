resource "aws_lb" "demo-lb" {
  name               = "demo-lb"
  load_balancer_type = "application"
  internal           = false
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.load_balancer_security_group.id]
}

resource "aws_lb_target_group" "lb_target_group" {
  name        = "demo-group"
  port        = "8080"
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = module.vpc.vpc_id
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 30
    interval            = 60
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http-listener" {
  load_balancer_arn = aws_lb.demo-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}
