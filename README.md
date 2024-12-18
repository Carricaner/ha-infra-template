## Commands

- apply
    ```
    terraform apply \
    -var-file=../../shared/shared-variables.tfvars \
    -var-file=dev.tfvars
    ```



## Notes

- AZs output

    ```json
    AZs = {
            group_names = [
                "ap-northeast-1",
            ]
            id          = "ap-northeast-1"
            names       = [
                "ap-northeast-1a",
                "ap-northeast-1c",
                "ap-northeast-1d",
            ]
            state       = "available"
            zone_ids    = [
                "apne1-az4",
                "apne1-az1",
                "apne1-az2",
            ]
        }
    ```