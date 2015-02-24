output "public_addr__webhead__http" {
    value = "${aws_elb.web_elb.dns_name}"
}

#output "public_addr__webhead__http" {
#    value = "${aws_elb.rabbit_elb.dns_name}"
#}
#
#output "public_addr__webhead__http" {
#    value = "${aws_elb.db_elb.dns_name}"
#}
