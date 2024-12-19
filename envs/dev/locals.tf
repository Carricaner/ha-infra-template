data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name_prefix     = "${var.project_name}_${var.environment}"
  available_zones = slice(data.aws_availability_zones.available.names, 0, 2)

  ec2 = {
    ami_id = "ami-0b5c74e235ed808b9"
  }
}