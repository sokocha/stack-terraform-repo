resource "aws_s3_bucket" "my-s3-bucket" {
  bucket_prefix = var.bucket_prefix
  force_destroy = true


  tags = {
    Name        = "My bucket"
    Environment = "Management"
  }

}


resource "aws_s3_bucket_acl" "my-s3-bucket" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  acl    = "private"

}

#BUCKET VERSIONING
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

#BUCKET LIFECYCLE CONFIG
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle-example" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  rule {
    id     = "archive_standard-ia_glacier"
    status = "Enabled"
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

#SERVER SIDE ENCRYPTION
resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption-example" {
  bucket = aws_s3_bucket.my-s3-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

