terraform {
  required_version = "~> 1.1.2"

  required_providers {
    aws = {
      version = "~> 4.13.0"
      source  = "hashicorp/aws"
    }
  }
}

# Download AWS provider
provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      ForMoreCoolStuff = "https://github.com/KyMidd"
      Author           = "Kyler Middleton"
      AuthorWebPage    = "https://kyler.omg.lol"
      WhoIsAwesome     = "You"
    }
  }
}
