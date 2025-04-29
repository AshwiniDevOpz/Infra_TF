# S3 Bucket Definition
resource "aws_s3_bucket" "example" {
  bucket        = var.bucket_name
  force_destroy = true

  versioning {
    enabled = true
  }

  logging {
    target_bucket = var.logging_bucket_name   # Must be created before
    target_prefix = "${var.bucket_name}/logs/"
  }

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# Block Public Access Settings (separate resource)
resource "aws_s3_bucket_public_access_block" "example_block" {
  bucket                  = aws_s3_bucket.example.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Server-Side Encryption (Option 1: SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.example.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # or use aws_kms_key for KMS
    }
  }
}
