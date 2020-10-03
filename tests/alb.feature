Feature: All resources for ALB should be created

    Scenario: Security Group to ALB should be created
        Given I have aws_security_group resource configured
        When its address is "module.alb.aws_security_group.sg"
        And its type is aws_security_group
        And it contains name
        Then its value must match the ".+-sg-alb-(tst|dev)" regex  