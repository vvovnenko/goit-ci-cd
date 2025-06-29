module "s3_backend" {
  source = "./modules/s3-backend"                # Шлях до модуля
  s3_bucket_name = "terraform-state-bucket-vvovnenko"  # Ім'я S3-бакета
  dynamodb_table_name  = "terraform-locks"                # Ім'я DynamoDB
}