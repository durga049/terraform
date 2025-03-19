
child module main.tf

resource "aws_s3_bucket" "new_bukcet_creating" {
    bucket = var.bukcetname-s3
}

variable.tf 

variable "bukcetname-s3" {
  
}

output.tf

output "name" {
  value = aws_s3_bucket.new_bukcet_creating.bucket_domain_name
}


root main.tf

module "getting_s3" {
  source        = "./storage"
  bukcetname-s3 = "durgacreatingbucketins3"

}

output "getting_output" {
  value = module.getting_s3.name

}
