
variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-example-instance"
}

variable "server_port" {
    description = "Port used for http requests"
    type        = number
    default     = 8080
}

variable "bucket_name" {
  description = "S3 Bucket name"
  type = string
  default = "brewer-terraform-running-state-1"
}

variable "cluster_name" {
  description = "Name to use for all cluster resources"
  type = string
}

variable "db_remote_state_bucket" {
  description = "Name of the S3 bucket for the db's remote state"
  type = string
}

variable "db_remote_state_key" {
  description = "Path for the database's remote state in s3"
  type = string
}

variable "instance_type" {
  description = "Type of EC2 instances to run"
  type = string
}

variable "min_size" {
  description = "Minimum number of EC2 instances"
  type = number
}

variable "max_size" {
  description = "Maximum number of EC2 instances in the ASG"
  type = number
}