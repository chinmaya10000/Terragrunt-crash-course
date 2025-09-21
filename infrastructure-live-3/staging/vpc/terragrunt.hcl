terraform {
    source = "../../../infrastructure-modules/vpc"
}

include {
    path   = find_in_parent_folders()
}

inputs = {
    vpc_cidr_block  = "10.0.0.0/16"
    env             = "staging"
    public_subnets  = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
    private_subnets = {
        private_1 = { cidr = "10.0.64.0/19", az = "us-east-2a" }
        private_2 = { cidr = "10.0.96.0/19", az = "us-east-2b" } 
        private_3 = { cidr = "10.1.160.0/19", az = "us-east-2c" }
    }
    azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
}
