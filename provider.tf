provider "aws" {
  secret_key = var.aws_secret_key
  access_key = var.aws_access_key
  region     = "eu-west-2"
}

terraform {
  cloud {
    organization = "bigspark"

    workspaces {
      name = "ecs-fargate"
    }
  }
}