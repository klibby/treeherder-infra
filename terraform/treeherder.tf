provider "aws" {
    region = "${var.aws_region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

# networking in network.tf
# aws_security_groups in secgroups.tf

resource "aws_elb" "web_elb" {
    name = "treeherder-web-elb"
    availability_zones = ["${aws_instance.web.*.availability_zone}"]
    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }
    /* Requires SSL
    listener {
        instance_port = 443
        instance_protocol = "https"
        lb_port = 443
        lb_protocol = "https"
    }
    */
    instances = ["${aws_instance.web.*.id}"]
    security_groups = ["${aws_security_group.any_to_elb__http.id}"]
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
    key_name = "${var.key_name}"
    count = "${var.web_nodes}"
    security_groups = [
        "${aws_security_group.elb_to_web__http.name}",
        "${aws_security_group.nodes_to_web__memcache.name}",
        "${aws_security_group.admin_to_web__http.name}",
        "${aws_security_group.admin_to_nodes__ssh.name}",
    ]
}

resource "aws_instance" "etl" {
    ami = "${lookup(var.ami, var.aws_region)}"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    count = "${var.web_nodes}"
    security_groups = [
        "${aws_security_group.admin_to_nodes__ssh.name}",
    ]
}

resource "aws_instance" "log" {
    ami = "${lookup(var.ami, var.aws_region)}"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    count = "${var.web_nodes}"
    security_groups = [
        "${aws_security_group.admin_to_nodes__ssh.name}",
    ]
}

