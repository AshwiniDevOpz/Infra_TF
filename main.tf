resource "aws_s3_bucket" "example" {
  bucket                  = var.bucket_name
  force_destroy           = true
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true

  # (your other settings)
}

