resource "aws_ecs_cluster" "main" {
  name= "app-cluster"
}


resource "aws_ecs_task_definition" "app" {
  family                   = "app-task"
  execution_role_arn       = "${aws_iam_role.ecs_task_execution_role.arn}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"
  lifecycle {
    # ignore_changes = [task_definition]  # Ignore changes to task_definition. We'll manage this with Terraform scripts. 
    create_before_destroy = true  # This is a workaround for Terraform not supporting depends_on properly.
    
  }
  container_definitions    = templatefile("./templates/ecs/cb_app.json.tpl", {
    app_image      = "${var.app_image}"
    app_port       = "${var.app_port}"
    fargate_cpu    = "${var.fargate_cpu}"
    fargate_memory = "${var.fargate_memory}"
    aws_region     = "${var.aws_region}"
  }
  )
}

resource "aws_ecs_service" "main" {
    name            = "cb-service"
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.app.arn
    desired_count   = var.app_count
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = [aws_security_group.ecs_tasks.id]
        subnets          = aws_subnet.private.*.id
        assign_public_ip = true
    }

    load_balancer {
        target_group_arn = aws_alb_target_group.app.id
        container_name   = "cb-app"
        container_port   = var.app_port
    }

    depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]
}