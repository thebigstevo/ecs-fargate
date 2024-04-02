[
  {
    "name": "${ollama_backend_container}",
    "image": "${ollama_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/ollama_backend",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "name":${ollama_backend_port},
        "containerPort": ${ollama_port},
        "hostPort": ${ollama_port}
      }
    ]
  },
   {
    "name": "${var.webui_container}",
    "image": "${webui_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/ollama-webui",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${webui_port},
        "hostPort": ${webui_port}
      }
    ]
  }
]
