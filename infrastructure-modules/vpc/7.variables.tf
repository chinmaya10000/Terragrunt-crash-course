variable "env" {
  description = "Environment name, e.g., dev, staging, prod"
  type = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "azs" {
  description = "List of Availability Zones to use for the VPC"
  type = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type = list(string)
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type = list(string)
}

variable "private_subnet_tags" {
  description = "Tags to apply to private subnets"
  type = map(any)
}

variable "public_subnet_tags" {
  description = "Tags to apply to public subnets"
  type = map(any)
  
}