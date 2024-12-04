# Policy document for EC2 Role Assumption
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Create an IAM Role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name               = "${var.cluster_name}-ec2-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Attach Administrator Access Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "ec2_admin_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Create an IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.cluster_name}-instance_profile"
  role = aws_iam_role.ec2_role.name
}

# Policy document for ECS, ECR, and CodeBuild permissions
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

# Create a new IAM role for ECS and CodeBuild
resource "aws_iam_role" "ecs_role" {
  name               = "${var.cluster_name}-ecs-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Attach custom ECS and ECR permissions policy
resource "aws_iam_role_policy" "ecs_ecr_policy" {
  name   = "${var.cluster_name}-ecs-ecr-policy"
  role   = aws_iam_role.ecs_role.name
  policy = data.aws_iam_policy_document.ecs_ecr_permissions.json
}

# Add CodePipeline permissions
data "aws_iam_policy_document" "codepipeline_permissions" {
  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:UploadArchive",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:CancelUploadArchive",
      "ecr:GetAuthorizationToken",
      "ecs:UpdateService",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "iam:PassRole"
    ]
    resources = ["*"]
  }
}

# Create a new IAM role for CodePipeline
resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.cluster_name}-codepipeline-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Attach custom CodePipeline permissions policy
resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "${var.cluster_name}-codepipeline-policy"
  role   = aws_iam_role.codepipeline_role.name
  policy = data.aws_iam_policy_document.codepipeline_permissions.json
}