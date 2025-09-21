variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type = string
}

variable "env" {
  description = "The environment for the VPC (e.g., dev, prod)"
  type = string
}

variable "public_subnets" {
  description = "A list of CIDR blocks for the public subnets"
  type = list(string)
}

variable "private_subnets" {
  description = "A map of names to CIDR blocks for the private subnets"
  type = map(object({ cidr = string, az = string }))
}

variable "azs" {
  description = "A list of availability zones for the subnets"
  type = list(string)
}