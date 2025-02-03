# HA Infrastrucutre Template

## Description

This project makes it easy to launch a variety of AWS services to build a high-availability infrastructure. By utilizing VPC, EC2, ALB, and ASG, it ensures robust performance, scalability, and reliability.

## Architecture

<img src="https://the-general.s3.ap-northeast-1.amazonaws.com/project/ha-infra-template.svg" width="750" alt="HA Infra Template Architecture"/>


## Commands
- apply
    ```
    terraform apply \
    -var-file=../../shared/shared-variables.tfvars \
    -var-file=dev.tfvars
    ```

## TODOs
- [V] Use ELB's health check
- [V] Create one NAT Gateway for each AZ


## Notes
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