terraform {
  required_version = "~>1.0.8"

//  backend "s3" {
//    bucket         = "terraform-state-try-save"
//    encrypt        = true
//    key            = "main-infra/terraform.tfstate"
//    region         = "us-east-1"
//    dynamodb_table = "terraform-locks"
//  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.62.0"
    }
  }
}