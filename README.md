## Commands
- apply
    ```
    terraform apply \
    -var-file=../../shared/shared-variables.tfvars \
    -var-file=dev.tfvars
    ```

## TODOs
- [] Use ELB's health check
- [] Create one NAT Gateway for each AZ
- [] Make it possible to dynamically adjust the number of AZ.


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

    ALB --> L1 --> TG1
    ALB --> L2 --> TG2
    ALB --> L3 --> TG2
    ```