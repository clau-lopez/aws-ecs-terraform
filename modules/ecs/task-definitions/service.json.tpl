[
   {
      "name":"${container_name}",
      "image":"${container_image}",
      "essential":true,
      "portMappings":[
         {
            "containerPort":${container_port},
            "hostPort":${container_port}
         }
      ],
         "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${awslogs_group}",
            "awslogs-region": "${region}",
            "awslogs-stream-prefix": "ecs"
          }
        
     }
   }
]