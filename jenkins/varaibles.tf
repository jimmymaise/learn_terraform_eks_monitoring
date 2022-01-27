variable "aws-region" {
  default = "us-west-2"
  type    = string
}
variable "bucket-config-name" {
  default = "petproject-jenkins-config"
  type    = string
}


variable "admin-username" {
  default = "admin"
  type    = string
}

variable "admin-password" {
  default = "admin"
  type    = string
}

variable "admin-fullname" {
  default = "admin fullname"
  type    = string
}

variable "admin-email" {
  default = "admin@admin.com"
  type    = string
}

variable "remote-repo" {
  default = "https://gitlab.com/jimmy-pet-projects/terraform-eks-with-monitoring"
  type    = string
}

variable "job-name" {
  default = "jenkins terraform job"
  type    = string
}
