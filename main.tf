# Create the S3 buckets
resource "aws_s3_bucket" "example" {
  bucket        = var.bucket_name
  force_destroy = true

  versioning {
    enabled = true
  }

  logging {
    target_bucket = var.logging_bucket_name # Must be created before
    target_prefix = "${var.bucket_name}/logs/"
  }

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# Block public access settings
resource "aws_s3_bucket_public_access_block" "example_block" {
  bucket                  = aws_s3_bucket.example.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# KMS Key for encryption
resource "aws_kms_key" "s3_key" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# Alias for the KMS key
resource "aws_kms_alias" "s3_key_alias" {
  name          = "alias/${var.bucket_name}-kms"
  target_key_id = aws_kms_key.s3_key.key_id
}

# S3 Bucket Server-Side Encryption using Customer Managed Key
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.example.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_key.arn
    }
  }
}
