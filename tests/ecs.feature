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

    Scenario: ECS Task definition should be created
        Given I have aws_ecs_task_definition resource configured
        When its address is "module.ecs.aws_ecs_task_definition.main"
        And its type is "aws_ecs_task_definition"
        And its network_mode is "awsvpc"
        And its requires_compatibilities is "FARGATE"
        And it has execution_role_arn
    
    Scenario: ECS Service should be created
        Given I have aws_ecs_service resource configured
        When its address is "module.ecs.aws_ecs_service.main"
        And it has cluster
        And its desired_count is 2
        And its deployment_minimum_healthy_percent is 50
        And its deployment_maximum_percent is 200
        And its launch_type is "FARGATE"
        And its scheduling_strategy is "REPLICA"
        And it has network_configuration
        And it has assign_public_ip
        And it has load_balancer
        Then it must contain name
        And its value must match the "^.+-ecs-service-(tst|dev)$" regex

    Scenario: Cloudwatch logs group should be created
        Given I have aws_cloudwatch_log_group resource configured
        When its address is "module.ecs.aws_cloudwatch_log_group.logs-ecs"
        And its type is aws_cloudwatch_log_group
        Then it must contain name
        And its value must match the "^.+-log-ecs-(tst|dev)$" regex