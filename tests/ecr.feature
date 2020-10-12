Feature: ECR should be created

    Scenario: ECR repository should be created
        Given I have aws_ecr_repository resource configured
        When its address is "module.ecr.aws_ecr_repository.main"
        And its image_tag_mutability is "MUTABLE" 
        And it has image_scanning_configuration
        When it contains name
        Then its value must match the "^.+-repository-(tst|dev)$" regex
        
    Scenario: ECR lifecycle policy should be created
        Given I have aws_ecr_lifecycle_policy resource configured
        When its name is "main"
        And its type is aws_ecr_lifecycle_policy
        And it has repository
        And it has policy
        And it has rules


