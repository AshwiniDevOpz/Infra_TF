resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
  force_destroy = true

  # (your other settings)
}

