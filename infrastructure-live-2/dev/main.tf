provider "aws" {
  region = local.aws_region
}

terraform {
  backend "local" {
    path = "dev/terraform.tfstate"
  }
}

module "vpc" {
  source          = "../../infrastructure-modules/vpc"

  vpc_cidr_block  = local.vpc_cidr_block
  env             = local.env
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
  azs             = local.azs
}

module "alb" {
  source            = "../../infrastructure-modules/alb"
  env               = local.env
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "asg" {
  source                = "../../infrastructure-modules/asg"
  env                   = local.env
  vpc_id                = module.vpc.vpc_id
  alb_sg_id             = module.alb.alb_sg_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  alb_target_group_arns = module.alb.alb_target_group_arn
  image_id              = local.image_id
  instance_type         = local.instance_type
}