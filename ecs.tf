resource "aws_ecs_cluster" "ollama" {
  name = "ollama-cluster"
}


resource "aws_ecs_task_definition" "ollama" {
  family                   = "ollama-task-definition"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.total_fargate_cpu
  memory                   = var.total_fargate_memory
  lifecycle {

  }
  container_definitions = templatefile("./templates/ecs/cb_app.json.tpl", {
    ollama_image             = "${var.ollama_image}"
    ollama_backend_container = "${var.ollama_backend_container}"
    ollama_backend_port      = "${var.ollama_backend_port}"
    webui_container          = "${var.webui_container}"
    webui_image              = "${var.webui_image}"
    ollama_port              = "${var.ollama_port}"
    webui_port               = "${var.webui_port}"
    fargate_cpu              = "${var.fargate_cpu}"
    fargate_memory           = "${var.fargate_memory}"
    aws_region               = "${var.aws_region}"
  })
}

resource "aws_ecs_service" "ollama_service" {
  name            = "ollama-service"
  cluster         = aws_ecs_cluster.ollama.id
  task_definition = aws_ecs_task_definition.ollama.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.webui_tg.id
    container_name   = var.webui_container
    container_port   = var.webui_port
  }

  depends_on = [aws_alb_listener.webui_li, aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]
}