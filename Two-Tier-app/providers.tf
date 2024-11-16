terraform {

   backend "s3" {
    bucket = "terraform-final-project-jjiimm"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock-file"
    encrypt = true
  }



  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}




















