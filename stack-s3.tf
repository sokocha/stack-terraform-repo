resource "aws_s3_bucket" "my-s3-bucket" {
  bucket_prefix = var.bucket_prefix


  tags = {
    Name        = "My bucket"
    Environment = "Management"
  }
}


resource "aws_s3_bucket_acl" "my-s3-bucket" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  acl    = "private"
  lifecycle_rule {
    id = "archive"
    enabled = true
    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days = 60
      storage_class = "GLACIER"
    }
  }

}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

