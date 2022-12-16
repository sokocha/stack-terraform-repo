#SOURCE BUCKET
resource "aws_s3_bucket" "source-bucket" {
  bucket_prefix = var.source_prefix
  force_destroy = true


  tags = {
    OwnerEmail = "sadiqokocha7@gmail.com"
    Stackteam = "stackcloud9"
    Schedule = "A"
    Backup = "yes"
    Environment = "Dev"
  }

}

resource "aws_s3_bucket_acl" "source-bucket" {
  bucket = aws_s3_bucket.source-bucket.id
  acl    = "private"

}
# END SOURCE BUCKET

#DESTINATION BUCKET
resource "aws_s3_bucket" "destination-bucket" {
  bucket_prefix = var.destination_prefix
  force_destroy = true


  tags = {
    OwnerEmail = "sadiqokocha7@gmail.com"
    Stackteam = "stackcloud9"
    Schedule = "A"
    Backup = "yes"
    Environment = "Dev"
  }

}

resource "aws_s3_bucket_acl" "destination-bucket" {
  bucket = aws_s3_bucket.destination-bucket.id
  acl    = "private"

}
#END DESTINATION BUCKET

#BUCKET VERSIONING



resource "aws_s3_bucket_versioning" "versioning_source_enabled" {
  bucket = aws_s3_bucket.source-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "versioning_source_disabled" {
  bucket = aws_s3_bucket.source-bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_versioning" "versioning_destination_enabled" {
  bucket = aws_s3_bucket.destination-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "versioning_destination_disabled" {
  bucket = aws_s3_bucket.destination-bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}


#END BUCKET VERSIONING

#BUCKET LIFECYCLE CONFIG
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle-example" {
  bucket = aws_s3_bucket.source-bucket.id
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
#resource "aws_kms_key" "mykey" {
 # description             = "This key is used to encrypt bucket objects"
  #deletion_window_in_days = 10
#}

#resource "aws_s3_bucket_server_side_encryption_configuration" "encryption-example" {
 # bucket = aws_s3_bucket.source-bucket.bucket

  #rule {
   # apply_server_side_encryption_by_default {
    #  kms_master_key_id = aws_kms_key.mykey.arn
     # sse_algorithm     = "aws:kms"
    #}
  #}
#}


# AWS S3 BUCKET POLICY
resource "aws_s3_bucket_policy" "site-policy" {
  bucket = aws_s3_bucket.source-bucket.bucket
  policy =  <<POLICY
{
  "Version": "2012-10-17",
  "Id": "StaticSiteBucketPolicy",
  	"Statement": [{
			"Sid": "Stmt1670409909975",
			"Effect": "Allow",
			"Principal": "*",
			"Action": "s3:*",
			"Resource": "arn:aws:s3:::${aws_s3_bucket.source-bucket.id}"
		},
		{
			"Sid": "PublicReadGetObject",
			"Effect": "Allow",
			"Principal": "*",
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::${aws_s3_bucket.source-bucket.id}/*"
		}
	]
}
POLICY
}

# CONFIGURE STATIC WEBSTIE
resource "aws_s3_bucket_website_configuration" "site-clone" {
  bucket = aws_s3_bucket.source-bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}

# BUCKET LOGGING
resource "aws_s3_bucket" "log_bucket" {
  bucket = "dalogbuckoko"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.log_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

# UPLOAD FILE TO BUCKET
resource "aws_s3_object" "object1" {
  bucket = aws_s3_bucket.source-bucket.bucket
  key = "index.html"
  source = "/Users/sadiqokocha/apps/python/index.html"
  etag = filemd5("/Users/sadiqokocha/apps/python/index.html")

}

resource "aws_s3_object" "object2" {
  bucket = aws_s3_bucket.source-bucket.bucket
  key = "error.html"
  source = "/Users/sadiqokocha/apps/python/error.html"
  etag = filemd5("/Users/sadiqokocha/apps/python/error.html")

}

#SERVER ACCESS LOGGING


#OBJECT LEVEL LOGGING
resource "aws_cloudtrail" "cloudtrail" {
  name  = "tf-trail-cloudtrail"
  s3_bucket_name = aws_s3_bucket.source-bucket.bucket
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3"]
    }
  }
}


#CROSS REGION REPLICATION





#CROSS ACCOUNT REPLICATION


