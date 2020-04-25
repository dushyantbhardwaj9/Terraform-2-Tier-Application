resource "aws_lb" "external" {
  name               = "external-load-balance"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.frontEnd.id ]
  subnets            = [aws_subnet.front_1.id, aws_subnet.front_2.id ]
  ip_address_type = "ipv4"
  
}

resource "aws_lb" "internal" {
  name               = "ilb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.backEnd.id ]
  subnets            = [ aws_subnet.back_1.id, aws_subnet.back_2.id ]
  ip_address_type = "ipv4"
    
}


resource "aws_lb_target_group" "front" {
  name     = "front"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
}

resource "aws_lb_target_group_attachment" "target_1_1" {
  target_group_arn = aws_lb_target_group.front.arn
  target_id        = aws_instance.front-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "target_1_2" {
  target_group_arn = aws_lb_target_group.front.arn
  target_id        = aws_instance.front-2.id
  port             = 80
}

resource "aws_lb_target_group" "back" {
  name     = "back"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
}

resource "aws_lb_target_group_attachment" "target_2_1" {
  target_group_arn = aws_lb_target_group.back.arn
  target_id        = aws_instance.back-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "target_2_2" {
  target_group_arn = aws_lb_target_group.back.arn
  target_id        = aws_instance.back-2.id
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.external.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front.arn
  }
}

resource "aws_lb_listener" "back_end" {
  load_balancer_arn = aws_lb.internal.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.back.arn
  }
}

# variable "dns_name"{
#   default = "http://${aws_lb.internal.dns_name}:80/api/data.php"
# }
/*
data "template_file" "init" {
  template = file("user_data_public_instance_1.sh")
  vars = {
    lb_dns_name_1 = "http://:${aws_lb.internal.dns_name}/api/data.php"
  }
}
*/

