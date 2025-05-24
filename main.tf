terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami_id = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  user_data = file("${path.module}/user_data.sh")
  vpc_security_group_ids = [module.alb.security_group_id]
  subnet_ids = var.subnet_ids
}

module "alb" {
  source = "./modules/alb"
  name = var.alb_name
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids
  target_group_port = var.app_port
}

module "asg" {
  source = "./modules/asg"
  name = var.asg_name
  launch_template_id = module.ec2_instance.launch_template_id
  vpc_zone_identifier = var.subnet_ids
  desired_capacity = var.desired_capacity
  min_size = var.min_size
  max_size = var.max_size
  target_group_arns = [module.alb.target_group_arn]
}

module "route53" {
  source = "./modules/route53"
  zone_name = var.domain_name
  record_name = var.record_name
  alb_dns_name = module.alb.dns_name
}
