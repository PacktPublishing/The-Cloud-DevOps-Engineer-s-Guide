# ECS CLUSTER
resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-cluster"
}

# SECURITY GROUP FOR ECS INSTANCES
resource "aws_security_group" "ecs_sg" {
  name   = "${var.project_name}-ecs-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow outbound access to EFS (NFS Port 2049)
  egress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    description     = "Access to EFS"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS OPTIMIZED AMI
data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

# LAUNCH TEMPLATE
resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "${var.project_name}-lt"
  image_id      = data.aws_ami.ecs_optimized.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  vpc_security_group_ids = [aws_security_group.ecs_sg.id]

  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
EOF
  )
}

# AUTO SCALING GROUP
resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity    = var.desired_capacity
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = aws_subnet.public[*].id
  
  health_check_type         = "EC2"
  health_check_grace_period = 300
  
  wait_for_elb_capacity = 0
  wait_for_capacity_timeout = "0"

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }
  
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}

# ECS TASK EXECUTION ROLE
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-ecs-task-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS TASK DEFINITION
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  # DEFINE THE VOLUME
  volume {
    name = "efs-storage"
    efs_volume_configuration {
      # We reference the EFS created in efs.tf
      file_system_id = aws_efs_file_system.fs.id 
      root_directory = "/"
    }
  }

  container_definitions = jsonencode([
    {
      name      = "pastel-notes-app"
      image     = aws_ecr_repository.repo.repository_url
      essential = true

      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]

      # MOUNT THE VOLUME
      mountPoints = [
        {
          sourceVolume  = "efs-storage"
          containerPath = "/app/backend/data"
          readOnly      = false
        }
      ]
    }
  ])
}

# ECS SERVICE
resource "aws_ecs_service" "app_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "EC2"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "pastel-notes-app"
    container_port   = 3000
  }

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }

  depends_on = [
    aws_lb_listener.prod_listener,
    aws_lb_listener.test_listener
  ]
}