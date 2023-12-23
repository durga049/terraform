output "vpc_name" {
value = [ "${data.aws_vpc.pratice.id}"]
}
output "vpc_ower_id" {
value = [ "${data.aws_vpc.pratice.owner_id}"]
}
