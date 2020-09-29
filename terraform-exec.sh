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
terraform plan