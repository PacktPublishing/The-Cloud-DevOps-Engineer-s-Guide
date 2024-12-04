resource "aws_ecr_repository" "ecr_repository" {
  name                 = "flask-webapp" # Change for a more appropriate name
  image_tag_mutability = "MUTABLE"  # Options: MUTABLE or IMMUTABLE
  
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "my-ECR-repository" # This can also be changed to a more appropriate tag name
  }
}

resource "aws_ecs_cluster" "cluster" {  
  name = "${var.cluster_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_capacity_provider" "capacity" {   
  name = "${var.cluster_name}-capacity_provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.autoscaling_group.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {
  cluster_name       = aws_ecs_cluster.cluster.name
  capacity_providers = [aws_ecs_capacity_provider.capacity.name]
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${var.task_family}"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "${var.container_name}"
    image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/${var.container_image}"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }]
  }])
}

resource "aws_ecs_service" "service" {
  name            = "${var.service_name}"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1

  launch_type = "EC2"

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:cluster_type == web"
  }
}