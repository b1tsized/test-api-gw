terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

### AWS ###

provider "aws" {
  region  = var.region
  profile = var.profile
}
