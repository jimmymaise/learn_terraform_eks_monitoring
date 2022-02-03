variable "jenkins_secrets" {
  default = {
    "AWS_ACCESS_KEY" = "this is invalid key"
    "AWS_SECRET_KEY" = "this is invalid secret"
  }
  type    = map
}

variable "aws_region" {
  default = "us-west-2"
  type    = string
}
variable "bucket_config_name" {
  default = "petproject-jenkins-config"
  type    = string
}


variable "admin_username" {
  default = "admin"
  type    = string
}


variable "eks_monitoring_secret" {
  default = {
    "wp_sql_password" : "admin",
    "grafana_password" : "admin"
  }
  sensitive = true
}
variable "admin_password" {
  default   = "admin"
  type      = string
  sensitive = true
}

variable "admin_fullname" {
  default = "admin fullname"
  type    = string
}

variable "admin_email" {
  default = "admin@admin.com"
  type    = string
}

variable "remote_repo" {
  default = "https://gitlab.com/jimmy-pet-projects/terraform-eks-with-monitoring"
  type    = string
}

variable "job_name" {
  default = "jenkins terraform job"
  type    = string
}
