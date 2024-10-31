# Security Group Definition
resource "aws_security_group" "app_sg" {
  name        = "${var.owners}-${var.environment}-app-sg"
  description = "Allow inbound traffic for application and SSH"
  vpc_id      = var.vpc_id

  # Allow HTTP traffic on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH access on port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with specific IP range if needed
  }

  # Allow Jenkins connection on port 8080
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with specific IP range if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.owners}-${var.environment}-app-sg"
    Environment = var.environment
  }
}

# Jenkins Server Instance
resource "aws_instance" "jenkins_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnets[0] # Adjust based on your subnet variable
  vpc_security_group_ids = [aws_security_group.app_sg.id] # Attach the correct security group

  user_data = <<-EOF
    #!/bin/bash
    # Update packages
    sudo apt update

    # Install Java
    sudo apt install openjdk-17-jdk openjdk-17-jre -y

    # Install Jenkins
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt update
    sudo apt install jenkins -y
    sudo systemctl start jenkins
    sudo systemctl enable jenkins

    # Install Docker and BuildX
    sudo apt install docker.io -y
    sudo apt install docker-buildx -y
	sudo systemctl start docker
    sudo systemctl enable docker

    # Add Jenkins and ubuntu users to the Docker group
    sudo usermod -aG docker jenkins
    sudo usermod -aG docker ubuntu
    sudo systemctl restart jenkins

    # Install AWS CLI
    sudo apt install unzip -y
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
	
	# Install Git
	sudo apt install git -y
  EOF

  tags = {
    Name        = "${var.owners}-${var.environment}-jenkins-server"
    Environment = var.environment
  }
}

# Web Application Instance
resource "aws_instance" "app" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnets[1] # Adjust based on your subnet variable
  vpc_security_group_ids = [aws_security_group.app_sg.id] # Attach the correct security group

  user_data = <<-EOF
    #!/bin/bash
    # Update packages
    sudo apt update

    # Install Docker and BuildX
    sudo apt install docker.io -y
    sudo apt install docker-buildx -y
	sudo systemctl start docker
    sudo systemctl enable docker
	
	# Add ubuntu user to the Docker group
    sudo usermod -aG docker ubuntu
    sudo systemctl restart jenkins

    # Install AWS CLI
    sudo apt install unzip -y
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
	
	# Install Git
	sudo apt install git -y
  EOF

  tags = {
    Name        = "${var.owners}-${var.environment}-web-app"
    Environment = var.environment
  }
}
