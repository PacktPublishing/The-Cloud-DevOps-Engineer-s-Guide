module "ec2_instance" {
  source       = "./ec2"
  key_name     = var.key_name
}

module "iam_roles" {
  source = "./iam"
}

module "security_group" {
  source = "./sg"
}