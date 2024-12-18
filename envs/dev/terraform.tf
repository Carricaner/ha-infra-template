terraform {
  cloud {
    organization = "myoptionsv2"

    workspaces {
      project = "ha_infra_template"
      name    = "ha_infra_template_dev"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
    }
  }
}