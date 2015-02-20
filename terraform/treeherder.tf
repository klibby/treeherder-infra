provider "aws" {
    region = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

# aws_security_groups in secgroups.tf

resource "aws_elb" "web_elb" {
    name = "treeherder-web-elb"
    availability_zones = ["${aws_instance.web.availability_zone}"]
    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }
    instances = ["${aws_instance.web.id}"]
}

# ideally, SQS
#resource "aws_elb" "rabbit_elb" {}
# ideally, RDS
#resource "aws_elb" "db_elb" {}

resource "aws_instance" "admin" {
    ami = "${lookup(var.ami, var.aws_region)}"
    instance_type = "t2.micro"
    security_groups = []
}

resource "aws_instance" "rabbitmq" {
    ami = "${lookup(var.ami, var.aws_region)}"
    instance_type = "t2.micro"
    security_groups = []
}

resource "aws_instance" "web" {
    ami = "${lookup(var.ami, var.aws_region)}"
    instance_type = "t2.micro"
    security_groups = []
}

resource "aws_instance" "etl" {
    ami = "${lookup(var.ami, var.aws_region)}"
    instance_type = "t2.micro"
    security_groups = []
}

resource "aws_instance" "log" {
    ami = "${lookup(var.ami, var.aws_region)}"
    instance_type = "t2.micro"
    security_groups = []
}

