# HA Infrastrucutre Template

## Description

This project makes it easy to launch a variety of AWS services to build a high-availability infrastructure. By utilizing VPC, EC2, ALB, and ASG, it ensures robust performance, scalability, and reliability.

## Architecture

<img src="https://the-general.s3.ap-northeast-1.amazonaws.com/project/ha-infra-template.svg" width="850" alt="HA Infra Template Architecture"/>

## Prerequisites

- Terraform
- AWS CLI

## Steps
1. Configure AWS CLI and make sure the IAM user has corresponding rights
    
    ```shell
    aws configure
    ```

2. Log in for Terraform
    
    ```shell
    terraform login
    ```

3. Configure the Terraform Cloud under `./envs/dev/terraform.tf`, and the format is like:
    
    ```terraform
    terraform {
        cloud {
            organization = <the-org>

            workspaces {
                project = <the-project>
                name    = <name>
            }
        }

        required_providers {
            aws = {
                source  = "hashicorp/aws"
                version = "~> 5.80"
            }
        }
    }
    ```

4. Initialize Terraform
    
    ```shell
    terraform init
    ```

5. Plan & apply the infrastructure
    
    ```shell
    make apply
    ```

## Notes
- After moving into the env folder, apply it with a command like
    
    ```bash
    terraform apply \
    -var-file=../../shared/shared-variables.tfvars \
    -var-file=dev.tfvars
    ```
    - The order of files matters, since the latter will overwrite the former's values.

-  It’s recommended to deploy a NAT Gateway in each AZ where you have private subnets, which avoiding cross-AZ data transfer fee and NAT Gatway outage.

- Relationships among ALBs, listners & target groups
    ```mermaid
    flowchart TD
    ALB
    L1{{Listener 1}}
    L2{{Listener 2}}
    L3{{Listener 3}}
    TG1((Target Group 1))
    TG2((Target Group 2))

    ALB -->|attached with| L1
    ALB -->|attached with| L2
    ALB -->|attached with| L3

    L1 -->|health check or send| TG1
    L2 -->|health check or send| TG2
    L3 -->|health check or send| TG2
    ```

## Future Work
- Adjust the number of AZs dynamically
- Adjust the desired, minimum & maximum number of instances under ASG dynamically.
- Configure scaling policies for ASD and scale the instances based on CloudWatch alarm's metrics, like average CPU or other custom metrics.