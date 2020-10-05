Feature: All resources for ECS should be created

    Scenario Outline: Security Group to ECS task should be created
        Given I have aws_security_group resource configured
        When its address is "module.ecs.aws_security_group.ecs_tasks"
        And its type is aws_security_group
        Then it must contain <policy_name>


        Examples:
      | policy_name   |
      | ingress       |
      | egress        |
        
    Scenario: ECS cluster should be created
        Given I have aws_ecs_cluster resource configured
        When it contains name
        Then its value must match the "^.+-cluster-(dev|prod|tst)$" regex

     Scenario Outline: AWS iam role should be created
        Given I have aws_iam_role resource configured
        When its address is "module.ecs.aws_iam_role.ecs_task_execution_role"
        And its type is aws_iam_role
        And it has assume_role_policy
        And it contains Statement
        Then it must contain <property>
        And its value must match the "<value>" regex

        Examples:
      | property      | value                                      |
      | Effect        | Allow                                      |
      | Action        | sts:AssumeRole                             |
      | Principal     | ecs-tasks.amazonaws.com                    |

      Scenario: AWS IAM role policy attachment should be created
        Given I have aws_iam_role_policy_attachment resource configured
        When its address is "module.ecs.aws_iam_role_policy_attachment.ecs_task_execution_role_policy_attachment"
        And its type is aws_iam_role_policy_attachment"
        And its name is "ecs_task_execution_role_policy_attachment"
        Then it must contain role
        And its value must match the ".+-ecsTaskExecutionRole-(tst|dev)" regex