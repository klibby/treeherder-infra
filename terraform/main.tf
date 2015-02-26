provider "aws" {
    region = "${var.aws_region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

# networking in network.tf
# aws_security_groups in secgroups.tf

resource "aws_elb" "web_elb" {
    name = "${var.app}-${var.env}-web"
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
        ssl_certificate_id = ""
    }
    */
    subnets = ["${aws_subnet.public_subnet.id}"]
#    availability_zones = ["${aws_instance.web.availability_zone}"]
    instances = ["${aws_instance.web.id}"]
    security_groups = ["${aws_security_group.any_to_elb__http.id}"]
}

# ideally, SQS
#resource "aws_elb" "rabbitmq_elb" {
#    name = "${var.app}-${var.env}-amqp"
#    listener {
#        instance_port = 5672
#        instance_protocol = "amqp"
#        lb_port = 5672
#        lb_protocol = "amqp"
#    }
#    internal = true
#    subnets = ["${aws_subnet.public_subnet.id}"]
#    availability_zones = ["${aws_instance.rabbitmq.*.availability_zone}"]
#    #subnets = ["${aws_subnet.public_subnet.id}"]
#    instances = ["${aws_instance.rabbitmq.*.id}"]
#    security_groups = ["${aws_security_group.nodes_to_elb__amqp.id}"]
#}

# ideally, RDS
#resource "aws_elb" "db_elb" {}

resource "aws_instance" "admin" {
    ami = "${lookup(var.ami, var.aws_region)}"
    instance_type = "t2.micro"
    iam_instance_profile = "ec2-read-tags"
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.public_subnet.id}"
    security_groups = [
        "${aws_security_group.any_to_admin__ssh.id}",
    ]
    tags {
        Name = "treeherder-admin"
        App = "treeherder"
        Type = "admin"
        Env = "test"
        Stack = "treeherder-aws-test"
        Owner = "fubar"
    }
}

#resource "aws_instance" "rabbitmq" {
##    ami = "${lookup(var.ami, var.aws_region)}"
#    instance_type = "t2.micro"
#    subnet_id = "${aws_subnet.public_subnet.id}"
#    key_name = "${var.key_name}"
#    security_groups = [
#        "${aws_security_group.elb_to_rabbitmq__amqp.id}",
#        "${aws_security_group.admin_to_nodes__ssh.id}",
#    ]
#    tags {
#        Name = "treeherder-rabbitmq"
#        App = "treeherder"
#        Type = "rabbitmq"
#        Env = "test"
#        Stack = "treeherder-aws-test"
#        Owner = "fubar"
#    }
#}

resource "aws_instance" "web" {
    ami = "${lookup(var.ami, var.aws_region)}"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.public_subnet.id}"
    key_name = "${var.key_name}"
    security_groups = [
        "${aws_security_group.elb_to_web__http.id}",
        "${aws_security_group.nodes_to_web__memcache.id}",
        "${aws_security_group.admin_to_web__http.id}",
        "${aws_security_group.admin_to_nodes__ssh.id}",
    ]
    tags {
        Name = "treeherder-web"
        App = "treeherder"
        Type = "web"
        Env = "test"
        Stack = "treeherder-aws-test"
        Owner = "fubar"
    }
}

#resource "aws_instance" "etl" {
#    ami = "${lookup(var.ami, var.aws_region)}"
#    instance_type = "t2.micro"
#    subnet_id = "${aws_subnet.public_subnet.id}"
#    key_name = "${var.key_name}"
#    security_groups = [
#        "${aws_security_group.admin_to_nodes__ssh.id}",
#    ]
#    tags {
#        Name = "treeherder-etl"
#        App = "treeherder"
#        Type = "etl"
#        Env = "test"
#        Stack = "treeherder-aws-test"
#        Owner = "fubar"
#    }
#}

resource "aws_instance" "processor" {
    ami = "${lookup(var.ami, var.aws_region)}"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.public_subnet.id}"
    key_name = "${var.key_name}"
    security_groups = [
        "${aws_security_group.admin_to_nodes__ssh.id}",
    ]
    tags {
        Name = "treeherder-processor"
        App = "treeherder"
        Type = "processor"
        Env = "test"
        Stack = "treeherder-aws-test"
        Owner = "fubar"
    }
}

