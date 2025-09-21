locals {
  aws_region      = "us-east-2"
  env             = "dev"
  vpc_cidr_block  = "10.0.0.0/16"
  azs             = ["us-east-2a", "us-east-2b"]
  public_subnets  = ["10.0.0.0/19", "10.0.32.0/19"]
  private_subnets = {
    private_1 = { cidr = cidrsubnet(local.vpc_cidr_block, 3, 2), az = local.azs[0] }
    private_2 = { cidr = cidrsubnet(local.vpc_cidr_block, 3, 3), az = local.azs[1] }
  }

  image_id      = "ami-0b016c703b95ecbe4"
  instance_type = "t3.micro"
}
