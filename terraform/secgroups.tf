resource "aws_security_group" "any_to_elb__http" {
    name = "${var.app}_${var.env}__any_to_elb__http"
    description = "Allow incoming traffic from Internet to HTTP(S) on ELBs."
    vpc_id = "${var.aws_vpc_id}"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "elb_to_web__http" {
    name = "${var.app}_${var.env}__elb_to_web__http"
    description = "Allow HTTP(S) from ELBs to web nodes."
    vpc_id = "${var.aws_vpc_id}"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = ["${aws_security_group.any_to_elb__http.id}"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        security_groups = ["${aws_security_group.any_to_elb__http.id}"]
    }
}

# ideally, SQS
resource "aws_security_group" "nodes_to_elb__amqp" {
    name = "${var.app}_${var.env}__nodes_to_elb__amqp"
    description = "Allow incoming traffic from Treeherder nodes to AMQP on ELBs."
    vpc_id = "${var.aws_vpc_id}"
    ingress {
        from_port = 5672
        to_port = 5672
        protocol = "tcp"
        cidr_blocks = ["${var.subnet_cidr_block}"]
    }
}

resource "aws_security_group" "elb_to_rabbit__amqp" {
    name = "${var.app}_${var.env}__elb_to_rabbit__amqp"
    description = "Allow AMQP from ELBs to rabbit nodes."
    vpc_id = "${var.aws_vpc_id}"
    ingress {
        from_port = 5672
        to_port = 5672
        protocol = "tcp"
        security_groups = ["${aws_security_group.nodes_to_elb__amqp.id}"]
    }
}

# ideally, RDS
resource "aws_security_group" "nodes_to_elb__mysql" {
    name = "${var.app}_${var.env}__nodes_to_elb__mysql"
    description = "Allow incoming traffic from Treeherder nodes to MySQL on ELBs."
    vpc_id = "${var.aws_vpc_id}"
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["${var.subnet_cidr_block}"]
    }
}

resource "aws_security_group" "elb_to_db__mysql" {
    name = "${var.app}_${var.env}__elb_to_db__mysql"
    description = "Allow MySQL from ELBs to DB nodes."
    vpc_id = "${var.aws_vpc_id}"
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = ["${aws_security_group.nodes_to_elb__mysql.id}"]
    }
}

# elasticache?
resource "aws_security_group" "nodes_to_web__memcache" {
    name = "${var.app}_${var.env}__nodes_to_web__memcache"
    description = "Allow incoming traffic from Treeherder nodes to memcache on web nodes."
    vpc_id = "${var.aws_vpc_id}"
    ingress {
        from_port = 11211
        to_port = 11211
        protocol = "tcp"
        cidr_blocks = ["${var.subnet_cidr_block}"]
    }
}

resource "aws_security_group" "any_to_admin__ssh" {
    name = "${var.app}_${var.env}__any_to_admin__ssh"
    description = "Allow SSH to admin nodes."
    vpc_id = "${var.aws_vpc_id}"
    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "admin_to_web__http" {
    name = "${var.app}_${var.env}__admin_to_web__http"
    description = "Allow incoming traffic from admin node to HTTP(s) on web nodes."
    vpc_id = "${var.aws_vpc_id}"
}

resource "aws_security_group" "admin_to_nodes__ssh" {
    name = "${var.app}_${var.env}__admin_to_nodes__ssh"
    description = "Allow incoming traffic from admin node to SSH on web nodes."
    vpc_id = "${var.aws_vpc_id}"
    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        security_groups = ["${aws_security_group.any_to_admin__ssh.id}"]
    }
}

