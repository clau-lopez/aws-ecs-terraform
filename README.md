# AWS ECS Terraform

## Deploying infrastructure

### Initialize the project

_**Precondition:** Remember to stay logged in before to follow with the next steps._

To preserve state in each execution I chose to save them in S3. It's recommended enable versioning in S3 to allow recovering the states.
There are many options to set the backend configuration, you can find them here https://www.terraform.io/docs/backends/config.html#partial-configuration,
but here I let you one:

```
terraform init \
-backend-config="region=$REGION" \ 
-backend-config="bucket=$BUCKET_NAME" \ 
-backend-config="key=$STATE_FILE_NAME"

```