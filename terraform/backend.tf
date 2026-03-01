terraform {
  backend "s3" {
    bucket         = "blue-green-848153448908-tf-state"
    key            = "infra/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}