terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.41.0"
    }
  }

  backend "s3" {
    bucket       = "harsh11-threetierarch-tfstate"
    key          = "projects/threetierarch/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Project   = "3Tier-Arch"
      ManagedBy = "Terraform"
    }
  }
}