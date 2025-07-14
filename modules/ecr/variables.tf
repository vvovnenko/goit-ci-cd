variable "ecr_name" {
  description = "Name of your ecr repository"
  type = string
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the S3 bucket"
  type = bool
  default = true
}