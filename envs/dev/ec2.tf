# resource "aws_security_group" "alb_sg" {
#   name   = "${local.name_prefix}_alb_sg"
#   vpc_id = aws_vpc.ha_template_vpc.id

#   tags = {
#     Name         = "${local.name_prefix}_alb_sg"
#     project_name = var.project_name
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "alb_sg_inbound_rule_for_http" {
#   security_group_id = aws_security_group.alb_sg.id

#   ip_protocol = "tcp"
#   cidr_ipv4   = "0.0.0.0/0"
#   from_port   = 80
#   to_port     = 80
# }

# resource "aws_vpc_security_group_ingress_rule" "alb_sg_inbound_rule_for_https" {
#   security_group_id = aws_security_group.alb_sg.id

#   ip_protocol = "tcp"
#   cidr_ipv4   = "0.0.0.0/0"
#   from_port   = 443
#   to_port     = 443
# }

# resource "aws_vpc_security_group_egress_rule" "alb_sg_outbound_rule" {
#   security_group_id = aws_security_group.alb_sg.id

#   ip_protocol = "-1"
#   cidr_ipv4   = "0.0.0.0/0"
# }

# resource "aws_security_group" "ec2_sg" {
#   name   = "${local.name_prefix}_ec2_sg"
#   vpc_id = aws_vpc.ha_template_vpc.id

#   tags = {
#     Name         = "${local.name_prefix}_ec2_sg"
#     project_name = var.project_name
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "ec2_sg_inbound_rule" {
#   security_group_id            = aws_security_group.ec2_sg.id
#   referenced_security_group_id = aws_security_group.alb_sg.id

#   ip_protocol = "-1"
# }

# resource "aws_vpc_security_group_egress_rule" "ec2_sg_outbound_rule" {
#   security_group_id = aws_security_group.ec2_sg.id

#   ip_protocol = "-1"
#   cidr_ipv4   = "0.0.0.0/0"
# }

# resource "aws_lb" "alb" {
#   name               = replace("${local.name_prefix}_alb", "_", "-")
#   load_balancer_type = "application"
#   internal           = false
#   security_groups = [
#     aws_security_group.alb_sg.id
#   ]
#   subnets = aws_subnet.public_subnet[*].id
#   depends_on = [
#     aws_internet_gateway.internet_gateway
#   ]
# }

# resource "aws_lb_target_group" "alb_target_group" {
#   name     = replace("${local.name_prefix}_alb_tg", "_", "-")
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.ha_template_vpc.id

#   health_check {
#     enabled             = true
#     path                = "/"
#     protocol            = "HTTP"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#     matcher             = "200-299"
#   }

#   tags = {
#     Name = "${local.name_prefix}_tg"
#   }
# }

# resource "aws_lb_listener" "alb_forward_listener" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_target_group.arn
#   }
#   tags = {
#     Name = "${local.name_prefix}_alb_forward_listener"
#   }
# }

# resource "aws_launch_template" "ec2_launch_template" {
#   name          = "${local.name_prefix}_ec2_launch_template"
#   image_id      = local.ec2.ami_id
#   instance_type = "t2.micro"

#   network_interfaces {
#     associate_public_ip_address = false
#     security_groups = [
#       aws_security_group.ec2_sg.id
#     ]
#   }

#   user_data = filebase64("userdata.sh")

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "${local.name_prefix}_ec2_instance"
#     }
#   }
# }

# resource "aws_autoscaling_group" "ec2_auto_scaling_group" {
#   name             = "${local.name_prefix}_ec2_auto_scaling_group"
#   desired_capacity = 1
#   min_size         = 1
#   max_size         = 3
#   target_group_arns = [
#     aws_lb_target_group.alb_target_group.arn
#   ]
#   vpc_zone_identifier = aws_subnet.private_subnet[*].id

#   launch_template {
#     id      = aws_launch_template.ec2_launch_template.id
#     version = "$Latest"
#   }

#   health_check_type         = "ELB"
#   health_check_grace_period = 300
# }