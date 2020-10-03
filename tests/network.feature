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
      | Name        | .+vpc-(tst\|dev)$   |
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
      | Name        | .+igw-(tst\|dev)$   |
      | Environment | ^(tst\|dev\)$       |

    Scenario Outline: Public subnet for availability zone A should be created
        Given I have aws_subnet resource configured
        When its address is "module.network.aws_subnet.public"
        And its index is 0
        And its cidr_block is "10.0.2.0/24" 
        And its availability_zone is "us-west-1a"
        And its map_public_ip_on_launch is true
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value                            |
      | Name        | .+-public-subnet-0-(tst\|dev)$   |
      | Environment | ^(tst\|dev\)$                    |
    
    Scenario Outline: Public subnet for availability zone B should be created
        Given I have aws_subnet resource configured
        When its address is "module.network.aws_subnet.public"
        And its type is aws_subnet
        And its index is 1
        And its cidr_block is "10.0.3.0/24" 
        And its availability_zone is "us-west-1b"
        And its map_public_ip_on_launch is true
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value                             |
      | Name        | .+-public-subnet-1-(tst\|dev)$    |
      | Environment | ^(tst\|dev\)$                     |
      
    Scenario Outline: Private subnet for availability zone A should be created
        Given I have aws_subnet resource configured
        When its address is "module.network.aws_subnet.private"
        And its type is aws_subnet
        And its index is 0
        And its cidr_block is "10.0.0.0/24" 
        And its availability_zone is "us-west-1a"
        And its map_public_ip_on_launch is false
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value                              |
      | Name        | .+-private-subnet-0-(tst\|dev)$    |
      | Environment | ^(tst\|dev\)$                      |

    
    Scenario Outline: Private subnet for availability zone B should be created
        Given I have aws_subnet resource configured
        When its address is "module.network.aws_subnet.private"
        And its type is aws_subnet
        And its index is 1
        And its cidr_block is "10.0.1.0/24" 
        And its availability_zone is "us-west-1b"
        And its map_public_ip_on_launch is false
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value                                |
      | Name        | .+-private-subnet-1-(tst\|dev)$      |
      | Environment | ^(tst\|dev\)$                        |

    Scenario Outline: Route table for public subnet in availability zone A should be created
        Given I have aws_route_table resource configured
        When its address is "module.network.aws_route_table.public"
        And its type is "aws_route_table"
        And its index is 0
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value                                |
      | Name        | .+-route-table-public-0-(tst\|dev)$  |
      | Environment | ^(tst\|dev\)$                        |

    Scenario Outline: Route table for public subnet in availability zone B should be created
        Given I have aws_route_table resource configured
        When its address is "module.network.aws_route_table.public"
        And its type is "aws_route_table"
        And its index is 1
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value                                |
      | Name        | .+-route-table-public-1-(tst\|dev)$  |
      | Environment | ^(tst\|dev\)$                        |

    Scenario: Route to public subnet in availability zone A should be created
        Given I have aws_route resource configured
        When its address is "module.network.aws_route.public"
        And its type is "aws_route"
        And its index is 0
        And its destination_cidr_block is "0.0.0.0/0"


    Scenario: Route to public subnet in availability zone B should be created
        Given I have aws_route resource configured
        When its address is "module.network.aws_route.public"
        And its type is "aws_route"
        And its index is 1
        And its destination_cidr_block is "0.0.0.0/0"

    Scenario: Route table association to public subnet in availability zone A should be created
        Given I have aws_route_table_association resource configured
        When its address is "module.network.aws_route_table_association.public"
        And its type is "aws_route_table_association"
        And its index is 0

    Scenario: Route table association to public subnet in availability zone B should be created
        Given I have aws_route_table_association resource configured
        When its address is "module.network.aws_route_table_association.public"
        And its type is "aws_route_table_association"
        And its index is 1

    Scenario Outline: Elastic IP for NAT Gateway in availability zone A should be created
        Given i have aws_eip resource configured
        When its name is "eip"
        And its index is 0
        And its vpc is true
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value                             |
      | Name        | .+-eip-0-(tst\|dev)$              |
      | Environment | ^(tst\|dev\)$                     |

    Scenario Outline: Elastic IP for NAT Gateway in availability zone B should be created
        Given i have aws_eip resource configured
        When its name is "eip"
        And its index is 1
        And its vpc is true
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value                             |
      | Name        | .+-eip-1-(tst\|dev)$              |
      | Environment | ^(tst\|dev\)$                     |
    
    
    Scenario Outline: NAT Gateway in availability zone A should be created
        Given I have aws_nat_gateway resource configured
        When its address is "module.network.aws_nat_gateway.nat"
        And its index is 0
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value                             |
      | Name        | .+-ngw-0-(tst\|dev)$              |
      | Environment | ^(tst\|dev\)$                     |

    Scenario Outline: NAT Gateway in availability zone B should be created
        Given I have aws_nat_gateway resource configured
        When its address is "module.network.aws_nat_gateway.nat"
        And its index is 1
        And it contains tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

        Examples:
      | tags        | value                             |
      | Name        | .+-ngw-1-(tst\|dev)$              |
      | Environment | ^(tst\|dev\)$                     |

    Scenario: Route to private subnet in availability zone A should be created
        Given I have aws_route resource configured
        When its address is "module.network.aws_route.private"
        And its type is "aws_route"
        And its index is 0
        And its destination_cidr_block is "0.0.0.0/0"
    
    Scenario: Route to private subnet in availability zone B should be created
        Given I have aws_route resource configured
        When its address is "module.network.aws_route.private"
        And its type is "aws_route"
        And its index is 1
        And its destination_cidr_block is "0.0.0.0/0"
      
    Scenario: Route table association to private subnet in availability zone A should be created
        Given I have aws_route_table_association resource configured
        When its address is "module.network.aws_route_table_association.private"
        And its type is "aws_route_table_association"
        And its index is 0

    Scenario: Route table association to private subnet in availability zone B should be created
        Given I have aws_route_table_association resource configured
        When its address is "module.network.aws_route_table_association.private"
        And its type is "aws_route_table_association"
        And its index is 1