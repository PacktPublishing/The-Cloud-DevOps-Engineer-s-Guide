# Policy document for ECS and ECR permissions
data "aws_iam_policy_document" "ecs_ecr_permissions" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecs:UpdateService",
      "ecs:RegisterTaskDefinition",
      "ecs:DescribeClusters",
      "ecs:DescribeServices",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

# Create an IAM role for ECS
resource "aws_iam_role" "ecs_role" {
  name               = "${var.cluster_name}-ecs-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

# Policy document for ECS Role Assumption
data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

# Attach custom ECS and ECR permissions policy
resource "aws_iam_role_policy" "ecs_ecr_policy" {
  name   = "${var.cluster_name}-ecs-ecr-policy"
  role   = aws_iam_role.ecs_role.name
  policy = data.aws_iam_policy_document.ecs_ecr_permissions.json
}

# Create an IAM instance profile for ECS
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.cluster_name}-instance-profile"
  role = aws_iam_role.ecs_role.name
}