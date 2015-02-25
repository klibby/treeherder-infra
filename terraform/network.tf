
resource "aws_subnet" "public_subnet" {
    vpc_id = "${var.aws_vpc_id}"
    cidr_block = "${var.subnet_cidr_block}"
    availability_zone = "${var.subnet_az}"
    map_public_ip_on_launch = true
    tags {
        Name = "treeherder-subnet"
        App = "treeherder"
        Type = "subnet"
        Env = "test"
        Stack = "treeherder-aws-test"
        Owner = "fubar"
    }
}

# for private subnet, replace gateway_id with instance_id of NAT instance
resource "aws_route_table" "public_route_table" {
    vpc_id = "${var.aws_vpc_id}"
    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${var.aws_igw_id}"
    }
    tags {
        Name = "treeherder-rt"
        App = "treeherder"
        Type = "rt"
        Env = "test"
        Stack = "treeherder-aws-test"
        Owner = "fubar"
    }
}

resource "aws_route_table_association" "public_route_table_association" {
    subnet_id = "${aws_subnet.public_subnet.id}"
    route_table_id = "${aws_route_table.public_route_table.id}"
}
