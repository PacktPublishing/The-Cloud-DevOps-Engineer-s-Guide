module "vpc" {
  source               = "./modules/vpc"
  aws_region           = var.aws_region
  cluster_name         = var.cluster_name
  vpc_cidr_block       = var.vpc_cidr_block
  vpc_public_subnets   = var.vpc_public_subnets
  vpc_private_subnets  = var.vpc_private_subnets
  environment          = var.environment
  vpc_name             = var.vpc_name
}

module "alb" {
  depends_on = [
    module.vpc
  ]

  source       = "./modules/alb"
  cluster_name = var.cluster_name

  network = {
    vpc_id  = module.vpc.vpc_id
    subnets = flatten([module.vpc.public_subnets])
  }
}

module "iam" {
  source       = "./modules/iam"
  cluster_name = var.cluster_name
}

module "cluster" {
  depends_on = [
    module.vpc,
    module.alb,
    module.iam
  ]

  source          = "./modules/ecs"
  cluster_name    = var.cluster_name
  container_name  = var.container_name
  container_image = var.container_image
  task_family     = var.task_family
  service_name    = var.service_name

  auto_scalling = {
    instance_type     = "t3.micro"
    desired_instances = 1
    min_instances     = 1
    max_instances     = 2
    key_name          = "your-key-pair" # Change it to your Key Pair
  }

  network = {
    vpc_id  = module.vpc.vpc_id
    subnets = flatten([module.vpc.private_subnets])
  }

  aws_lb_target_group_default_arn = module.alb.aws_lb_target_group_default_arn
  ecs_role_arn = module.iam.ecs_role_arn
  instance_profile_name  = module.iam.instance_profile_name
}