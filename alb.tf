resource "aws_alb" "main_lb" {
  name = "app-load-balancer"
  subnets= aws_subnet.public.*.id
   security_groups = [aws_security_group.alb_sg.id]
  }

resource "aws_alb_target_group" "app" {
name = "app-target-group"
port = 80
protocol = "HTTP"
vpc_id = aws_vpc.ecs-main.id
target_type = "ip"

health_check {
path = "/"
interval = 30
timeout = 10
unhealthy_threshold = 3
healthy_threshold = 2
}  
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
load_balancer_arn = aws_alb.main_lb.arn
port = "80"
protocol = "HTTP"

default_action {
target_group_arn = aws_alb_target_group.app.arn
type = "forward"
}
}