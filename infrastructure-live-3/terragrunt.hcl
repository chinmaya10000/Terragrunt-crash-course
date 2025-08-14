remote_state {
    backend = "local"
    generate = {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }

    config = {
        path = "${path_relative_from_include()}/terraform.tfstate"
    }
}

generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"

    contents = <<EOF
provider "aws" {
    region = "us-east-2"
}
EOF
}