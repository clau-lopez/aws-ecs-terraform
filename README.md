# AWS ECS Terraform

## Deploying infrastructure
This is an example 1.

This is other example 2.2
Example 3.3
example 4.4

### Selecting a _workspace_
This project uses the feature provided by Terraform to select a workspace. I'm leveraging this feature in order to enable the code to be compatible with multiples environments. In other words, based on the workspaces this code can be deployed in, for instance, _development_ as **dev** or _production_ as **prod**. In this case I'm using `dev` and `prod`. 

Setting dev environment

```
export ENVIRONMENT=dev
```


Creating a new workspace
```
terraform workspace new $ENVIRONMENT
```

Selecting an existing workspace
```
terraform workspace select $ENVIRONMENT
```

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
### Running tests

For testing the infrastructure I used terraform compliance, for more details visit the official documentation https://terraform-compliance.com. Test files are located in **_tests_** folder.

**Important:**
For running tests, I propose to create a new workspace dedicated to this. Specifically, I created a **tst** workspace that will allow generating a complete plan every time. Also, the variables of this workspace should exist in the `variables file`.

Creating workspace **tst**
```
terraform workspace new tst
```

Selecting workspace **tst**
```
terraform workspace select tst
```

Generate a plan to tests
```
terraform plan -out terraform.out
terraform show -json terraform.out > plan.json
```
Running tests 
```
terraform-compliance -p plan.json -f tests
```

