include {
    path = find_in_parent_folders()
}

dependencies {
    paths = ["../vpc", "../alb"]
}

terraform {
    source = "../../../infrastructure-modules/asg"
}

inputs = {
    env                  = "dev"
    vpc_id               = dependency.vpc.outputs.vpc_id
    alb_sg_id            = dependency.alb.outputs.alb_sg_id
    private_subnet_ids   = dependency.vpc.outputs.private_subnet_ids
    alb_target_group_arn = dependency.alb.outputs.all_tg_arns
    image_id             = "ami-0b016c703b95ecbe4"
    instance_type        = "t3.micro"
}