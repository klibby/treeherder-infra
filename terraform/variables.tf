variable "access_key" {}
variable "secret_key" {}
variable "environment" {}
variable "app" {
    default = "treeherder"
    description = "Application name."
}

variable "key_name" {
    description = "Name of the SSH keypair to use in AWS."
}

variable "key_path" {
    description = "Path to the private portion of the SSH key specified."
}

variable "region" {
    default = "us-west-2"
    description = "AWS region to launch servers."
}

# Custom made Ubuntu Precise 12.04 LTS (x64)
variable "ami" {
    default = {
        us-west-2 = "ami-a1e2c491"
    }
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
