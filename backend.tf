terraform {
backend "s3" {
bucket = "terraform-for-s312"
key = "july1.tfstate"
region = "us-east-1"
}
}
