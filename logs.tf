# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "ollama_log_group" {
  name              = "/ecs/ollama"
  retention_in_days = 30

  tags = {
    Name = "ollama"
  }
}

resource "aws_cloudwatch_log_stream" "ollama_log_stream" {
  name           = "ollama-log-stream"
  log_group_name = aws_cloudwatch_log_group.ollama_log_group.name
}

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "webui_log_group" {
  name              = "/ecs/webui"
  retention_in_days = 30

  tags = {
    Name = "webui"
  }
}

resource "aws_cloudwatch_log_stream" "webui_log_stream" {
  name           = "webui-stream"
  log_group_name = aws_cloudwatch_log_group.ollama_log_group.name
}