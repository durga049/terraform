resource "aws_iam_user" "default" {
count = length(var.user_name)
name = var.user_name[count.index]
}
variable user_name  {
type = list(string)
default = ["user1", "user2", "user3"]
}

output "user_details" {
description = "using for loop"
value = [for user in var.user_name : user]
}

resource "aws_s3_bucket" "default" {
for_each = var.bucket_name
bucket = each.value
}
variable "bucket_name" {
type = set(string)
default = ["mybucketterra1", "mybucketterra2", "mybucketterra3"]
}
