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
        us-west-2 = "ami-a1e2c491"
    }
    description = "customized Ubuntu Precise 12.04 LTS (x64)"
}

variable "key_name" {
    description = "Name of the SSH keypair to use in AWS."
}

variable "key_path" {
    description = "Path to the private portion of the SSH key specified."
}

variable "web_nodes" {
    default = "1"
    description = "The number of web worker nodes to launch."
}

variable "log_nodes" {
    default = "1"
    description = "The number of log worker nodes to launch."
}

variable "rabbitmq_nodes" {
    default = "1"
    description = "The number of rabbitmq worker nodes to launch."
}

variable "etl_nodes" {
    default = "1"
    description = "The number of etl worker nodes to launch."
}

variable "del_on_term" {
    default = "false"
}
