variable "ami-id" {
  type = string
}

variable "iam-instance-profile" {
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

variable "key-pair" {
  type = string
}

variable "network_interface_id" {
  type = string
}

variable "device-index" {
  type = number
}
# S3 Bucket storing jenkins user data

variable "s3-jenkins_config-id" {
  type = string
}
variable "public-dns" {
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

variable "bucket-logs-name" {
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