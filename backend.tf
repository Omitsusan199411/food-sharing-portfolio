terraform {
  required_version = "1.1.4"
  backend "s3" {
    bucket = "food-sharing-service-terraform-tfstate"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws"{
  region = "ap-northeast-1"
}