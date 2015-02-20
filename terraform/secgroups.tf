resource "aws_security_group" "any_to_elb__http" {
    name = "${var.environment}__any_to_elb__http"
    description = "Allow incoming traffic from Internet to HTTP(S) on ELBs."
}

resource "aws_security_group" "elb_to_web__http" {
    name = "${var.environment}__elb_to_web__http"
    description = "Allow HTTP(S) from ELBs to web nodes."
}

# ideally, SQS
resource "aws_security_group" "nodes_to_elb__amqp" {
    name = "${var.environment}__nodes_to_elb__amqp"
    description = "Allow incoming traffic from Treeherder nodes to AMQP on ELBs."
}

resource "aws_security_group" "elb_to_rabbit__amqp" {
    name = "${var.environment}__elb_to_rabbit__amqp"
    description = "Allow AMQP from ELBs to rabbit nodes."
}

# ideally, RDS
resource "aws_security_group" "nodes_to_elb__mysql" {
    name = "${var.environment}__nodes_to_elb__mysql"
    description = "Allow incoming traffic from Treeherder nodes to MySQL on ELBs."
}

resource "aws_security_group" "elb_to_db__mysql" {
    name = "${var.environment}__elb_to_db__mysql"
    description = "Allow MySQL from ELBs to DB nodes."
}

# elasticache?
resource "aws_security_group" "nodes_to_web__memcache" {
    name = "${var.environment}__nodes_to_web__memcache"
    description = "Allow incoming traffic from Treeherder nodes to memcache on web nodes."
}

resource "aws_security_group" "any_to_admin__ssh" {
    name = "${var.environment}__any_to_admin__ssh"
    description = "Allow SSH to admin nodes."
    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "admin_to_web__http" {
    name = "${var.environment}__admin_to_web__http"
    description = "Allow incoming traffic from admin node to HTTP(s) on web nodes."
}

resource "aws_security_group" "admin_to_nodes__ssh" {
    name = "${var.environment}__admin_to_nodes__ssh"
    description = "Allow incoming traffic from admin node to SSH on web nodes."
    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        security_groups = ["${aws_security_group.any_to_admin__ssh.id}"]
    }
}

