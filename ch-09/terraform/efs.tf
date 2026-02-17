# The File System
resource "aws_efs_file_system" "fs" {
  creation_token = "${var.project_name}-efs"
  encrypted      = true

  tags = {
    Name = "${var.project_name}-efs"
  }
}

# Security Group for EFS
resource "aws_security_group" "efs_sg" {
  name   = "${var.project_name}-efs-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Mount Targets
resource "aws_efs_mount_target" "mount" {
  count           = 2
  file_system_id  = aws_efs_file_system.fs.id
  subnet_id       = aws_subnet.public[count.index].id
  security_groups = [aws_security_group.efs_sg.id]
}

# STORE EFS ID IN PARAMETER STORE
resource "aws_ssm_parameter" "efs_id" {
  name  = "/${var.project_name}/efs-id"
  type  = "String"
  value = aws_efs_file_system.fs.id
}