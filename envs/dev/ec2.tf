resource "aws_security_group" "alb_sg" {
  name   = "${local.name_prefix}_alb_sg"
  vpc_id = aws_vpc.ha_template_vpc.id

  tags = {
    Name = "${local.name_prefix}_alb_sg"
    project_name = var.project_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_sg_inbound_rule_for_http" {
  security_group_id = aws_security_group.alb_sg.id

  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_sg_inbound_rule_for_https" {
  security_group_id = aws_security_group.alb_sg.id

  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "alb_sg_outbound_rule" {
  security_group_id = aws_security_group.alb_sg.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_security_group" "ec2_sg" {
  name   = "${local.name_prefix}_ec2_sg"
  vpc_id = aws_vpc.ha_template_vpc.id

  tags = {
    Name = "${local.name_prefix}_ec2_sg"
    project_name = var.project_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_sg_inbound_rule" {
  security_group_id            = aws_security_group.ec2_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id

  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "ec2_sg_outbound_rule" {
  security_group_id = aws_security_group.ec2_sg.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

