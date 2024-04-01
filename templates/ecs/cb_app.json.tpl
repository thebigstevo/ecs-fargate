[
  {
    "name": "cb-app",
    "image": "${app_image}",
    "cpu": "${fargate_cpu}",
    "cpu": "${tonumber(fargate_cpu)}",
    "memory": "${tonumber(fargate_memory)}",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/cb-app",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ]
  }
]