Feature: All resources for network should be created

    Scenario Outline: VPC should be created
        Given I have aws_vpc resource configured
        When its name is "main"
        And its type is "aws_vpc"
        And its cidr_block is "10.0.0.0/16"
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value               |
      | Name        | .+vpc-(tst\|dev)$      |
      | Environment | ^(tst\|dev\)$       |

    Scenario Outline: Internet Gateway should be created
        Given I have aws_internet_gateway resource configured
        When its name is "main"
        And its type is "aws_internet_gateway"
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value               |
      | Name        | .+igw-(tst\|dev)$      |
      | Environment | ^(tst\|dev\)$       |

    Scenario Outline: Public subnet for availability zone A should be created
        Given I have aws_subnet resource configured
        When its address is "module.network.aws_subnet.public"
        And its index is 0
        And its cidr_block is "10.0.2.0/24" 
        And its availability_zone is "us-west-2a"
        And its map_public_ip_on_launch is true
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value               |
      | Name        | .+[0]-(tst\|dev)$   |
      | Environment | ^(tst\|dev\)$       |
    
    Scenario Outline: Public subnet for availability zone B should be created
        Given I have aws_subnet resource configured
        When its address is "module.network.aws_subnet.public"
        And its type is aws_subnet
        And its index is 1
        And its cidr_block is "10.0.3.0/24" 
        And its availability_zone is "us-west-2b"
        And its map_public_ip_on_launch is true
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value                |
      | Name        | .+[1]-(tst\|dev)$    |
      | Environment | ^(tst\|dev\)$        |