terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
    region = "us-east-2"
}

resource "aws_db_instance" "example" {
  identifier_prefix = "prod-terraform-up-and-running"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  skip_final_snapshot = true
  db_name = "example_prod_database"


  # How to set username and password
  username = var.db_username
  password = var.db_password
}
terraform {
  backend "s3" {}
}
