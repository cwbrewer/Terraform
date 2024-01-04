remote_state {
  backend = "s3"
  config = {
    bucket = "brewer-terraform-running-state-1"
    
    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-up-and-running-locks"
  }
}