resource "aws_vpc" "default" {
cidr_block = "192.168.0.0/16"
enable_dns_hostnames = true
}
resource "aws_flow_log" "example" {
  log_destination      = aws_s3_bucket.default.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.default.id
}

resource "aws_s3_bucket" "default" {
bucket = "mynewbucketfortesting123a"

}
resource "aws_iam_role" "example" {
  name = "example"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "example" {
  name = "example"
  role = aws_iam_role.example.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "s3:PutObject",
        "s3:GetBucketAcl",
        "s3:GetBucketPolicy"

      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
