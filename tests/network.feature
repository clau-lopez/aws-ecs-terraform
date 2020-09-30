Feature: All resources for network should be created
    Scenario: VPC should be created
        Given I have aws_vpc resource configured
        When its name is "main"
        And its type is "aws_vpc"
        And its cidr_block is "10.0.0.0/16"
        And it has tags
        Then it must contain Environment
        And its value must be "dev"