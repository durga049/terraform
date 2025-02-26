
resource "aws_s3_bucket" "sample" {
  bucket = "my-tesst-buket"
   lifecycle {
    prevent_destroy = "true"
    ignore_changes = [ tags ]
    create_before_destroy = "true"
  }


}
