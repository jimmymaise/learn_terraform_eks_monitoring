variable "ami_id" {
  type = string
}

variable "iam_instance_profile" {
  default = ""
  type    = string
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
}

variable "name" {
  type = string
}

variable "key_pair" {
  type = string
}

variable "network_interface_id" {
  type = string
}

variable "device_index" {
  type = number
}
# S3 Bucket storing jenkins user data

variable "s3_jenkins_config_id" {
  type = string
}
variable "public_dns" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "admin_email" {
  type = string
}

variable "admin_fullname" {
  type = string
}

variable "bucket_logs_name" {
  type = string
}

variable "bucket_config_name" {
  type = string
}

variable "remote_repo" {
  type = string
}

variable "job_name" {
  type = string
}

variable "job_id" {
  type = string
}