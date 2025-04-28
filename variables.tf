
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "mybuckertss"
}

variable "aws_region" {
  description = "AWS Region to create the bucket"
  type        = string
  default     = "us-east-2"
}
