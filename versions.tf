terraform {
  required_version = ">= 1.1"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.0"
      configuration_aliases = [aws.virginia]
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}
