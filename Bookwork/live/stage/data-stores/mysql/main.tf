terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
/*    backend "s3" {
    bucket = "brewer-terraform-running-state"
    key = "global/s3/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
*/  
}

provider "aws" {
    region = "us-east-2"
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-up-and-running"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  skip_final_snapshot = true
  db_name = "example_database"


  # How to set username and password
  username = var.db_username
  password = var.db_password
}
terraform {
  backend "s3" {}
}
/*
terraform {
  backend "s3" {
    bucket = "brewer-terraform-running-state-1"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true    
  }
}
*/