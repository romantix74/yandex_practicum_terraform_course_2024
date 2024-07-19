terraform {
  backend "s3" {
    region         = "ru-central1"
    bucket         = "terraform-test-20240719"
    key            = "terraform.tfstate"

    dynamodb_table = "state-lock-table"

    endpoints = {
      s3       = "https://storage.yandexcloud.net",
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1g8t40gitjhm36h7m7n/etnt84a1t41sc3n6789n"
    }

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
