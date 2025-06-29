terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-vvovnenko" # Назва S3-бакета
    key            = "lesson-4/terraform.tfstate"   # Шлях до файлу стейту
    region         = "eu-north-1"                    # Регіон AWS
    dynamodb_table = "terraform-locks"              # Назва таблиці DynamoDB
    encrypt        = true                           # Шифрування файлу стейту
  }
}

