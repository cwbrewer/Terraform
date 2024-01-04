variable "bucket_name" {
  description = "S3 Bucket name"
  type = string
  default = "brewer-terraform-running-state-1"
}

variable "table_name" {
  description = "Dynamo table name"
  type = string
  default = "terraform-up-and-running-locks"
}
variable "db_username" {
  description = "DB username"
  type = string
  default = "cwbrewer"
}

variable "db_password" {
  description = "DB password"
  type = string
  default = "password"
}
