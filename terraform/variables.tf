variable "app" {
    default = "treeherder"
    description = "Application name."
}

variable "env" {}
variable "access_key" {}
variable "secret_key" {}

variable "aws_region" {
    default = "us-west-2"
    description = "Default AWS region to launch servers."
}

variable "subnet_az" {
    default = "us-west-2a"
    description = "Default availability zone to use."
}

# NB: using non-default VPC will require changing instance security_groups from .name to .id
variable "aws_vpc_id" {
    description = "ID of the VPC to use (not created by terraform)."
}

variable "aws_igw_id" {
    description = "Internet gateway ID of the VPC."
}

variable "subnet_cidr_block" {
    description = "CIDR block to use for the application subnet."
}

variable "ami" {
    default = {
        us-west-2 = "ami-d9c1e0e9"
    }
    description = "customized Ubuntu Precise 12.04 LTS (x64)"
}

variable "key_name" {
    description = "Name of the SSH keypair to use in AWS."
}

variable "key_path" {
    description = "Path to the private portion of the SSH key specified."
}

variable "del_on_term" {
    default = "false"
}
