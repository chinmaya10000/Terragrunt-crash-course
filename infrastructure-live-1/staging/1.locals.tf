locals {
  aws_region = "ap-south-1"
  vpc_cidr = "10.0.0.0/16"
  env = "staging"

  azs = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  public_subnets = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]

  private_subnets = {
    private_1 = { cidr = cidrsubnet(local.vpc_cidr, 3, 2), az   = local.azs[0] }
    private_2 = { cidr = cidrsubnet(local.vpc_cidr, 3, 3), az   = local.azs[1] }
    private_3 = { cidr = cidrsubnet(local.vpc_cidr, 3, 4), az   = local.azs[2] }
  }

  image_id = "ami-0f9708d1cd2cfee41"
  instance_type = "t3.micro"
}
