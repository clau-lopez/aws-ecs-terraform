Feature: All resources for ALB should be created

    Scenario: Security Group to ALB should be created
        Given I have aws_security_group resource configured
        When its address is "module.alb.aws_security_group.sg"
        And its type is aws_security_group
        And it contains name
        Then its value must match the ".+-sg-alb-(tst|dev)" regex

     Scenario Outline: Bucket to store ALB logs should be created
        Given I have aws_s3_bucket resource configured
        When its name is "lb_logs"
        And its type is aws_s3_bucket
        And its acl is "private"
        And its force_destroy is "true"
        And it has policy
        And it contains Statement
        Then it must contain <property>
        And its value must match the "<value>" regex

        Examples:
      | property      | value                                      |
      | Effect        | Allow                                      |
      | Action        | s3:PutObject                               |
      | Resource      | arn:aws:s3:::.+/AWSLogs/[0-9]/*            |
      | Principal     | arn:aws:iam::027434742980:root             |

    Scenario Outline: ALB should be created
        Given I have aws_lb resource configured
        When its address is "module.alb.aws_lb.main"
        And its internal is false
        And its load_balancer_type is "application"
        And its enable_deletion_protection is false
        And it has access_logs
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value                    |
      | Name        | .+-alb-(tst\|dev)        |
      | Environment | ^(tst\|dev)$             |