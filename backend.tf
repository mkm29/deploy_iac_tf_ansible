terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    region  = "us-east-1"
    bucket  = "terraform-state-2424523"
    key     = "terraform.tfstate"
    profile = "terraform"
  }
}
