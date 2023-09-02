terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.66.0"
    }
  }
}
# provider is aws and region I am creating resources in us-east-1
provider "aws" {
  region = "us-east-1"

}