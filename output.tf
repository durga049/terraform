output "vpc_name" {
value = [ "${data.aws_vpc.pratice.id}"]
}
output "vpc_name1" {
value = [ "${data.aws_vpc.pratice.owner_id}"]
}
