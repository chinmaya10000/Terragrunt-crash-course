include {
    path = find_in_parent_folders()
}

dependency "vpc" {
    config_path = "../vpc"
}

terraform {
    source = "../../../infrastructure-modules/alb"
}

inputs = {
    env               = "dev"
    vpc_id            = dependency.vpc.outputs.vpc_id
    public_subnet_ids = dependency.vpc.outputs.public_subnet_ids
}