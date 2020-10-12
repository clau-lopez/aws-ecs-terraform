Feature: All resources for RDS should be created

    Scenario Outline: Subnet group to RDS should be created
        Given I have aws_db_subnet_group resource configured
        When its address is "module.rds.aws_db_subnet_group.subnet_group"
        And its type is "aws_db_subnet_group"
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value                            |
      | Name        | .+rds-subnet-group-(tst\|dev)$   |
      | Environment | ^(tst\|dev)$                     |

     Scenario Outline: Security group to RDS should be created
        Given I have aws_security_group resource configured
        When its address is "module.rds.aws_security_group.rds_sg"
        And its type is "aws_security_group"
        Then it must contain <policy_name>


        Examples:
      | policy_name   |
      | ingress       |
      | egress        |

    Scenario Outline: RDS instance should be created
        Given I have aws_db_instance resource configured
        When its address is "module.rds.aws_db_instance.rds"
        And its type is "aws_db_instance"
        And its allocated_storage is 20
        And its engine is "postgres"
        And its engine_version is "9.6.11"
        And its instance_class is "db.t2.micro"
        And its skip_final_snapshot is true
        And its deletion_protection is false
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value                            |
      | Name        | .+-database-(tst\|dev)$   |
      | Environment | ^(tst\|dev)$                     |
    