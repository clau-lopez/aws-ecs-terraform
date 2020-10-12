#!/bin/sh


echo "************** Terraform Execution *************"

echo "Run -> Formatting: root folder"
terraform fmt
echo " "
for d in $(ls -1 modules)
do
  echo "Run -> Formatting: modules/$d folder"
  terraform fmt modules/$d
done
echo " "
echo "Run -> Validation"
terraform validate

echo " "
echo "Run -> Plan"
terraform plan -out terraform.out
terraform show -json terraform.out > plan.json

echo " "
echo "Run -> Tests"
function terraform_compliance { docker run --rm -v $(pwd):/target -i -t eerkunt/terraform-compliance "$@"; }
terraform_compliance -p plan.json -f tests

echo " "
echo "Cleaning..."
rm -rf plan.json terraform.out

echo " "
echo "************** Execution Terminated *************"
