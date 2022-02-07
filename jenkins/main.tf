module "ecr_quote_fe" {
  for_each    = {
    ecr_quote_fe_v1 = "ecr-quote-fe-v1"
    ecr_quote_fe_v2 = "ecr-quote-fe-v2"
  }
  ecr_name    = each.value
  environment = "prod"
  source      = "../modules/ecr"
}


resource "aws_secretsmanager_secret" "jenkins" {
  count                   = length(var.jenkins_secrets)
  name                    = "JENKINS_${element(keys(var.jenkins_secrets), count.index)}"
  recovery_window_in_days = 0
  tags                    = { "jenkins:credentials:type" : "string" }
}


resource "aws_secretsmanager_secret" "eks_monitoring_secret" {
  name                    = "eks_monitoring_secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "eks_monitoring_secret" {
  secret_id     = aws_secretsmanager_secret.eks_monitoring_secret.id
  secret_string = jsonencode(var.eks_monitoring_secret)
}


resource "aws_secretsmanager_secret_version" "jenkins" {
  count         = length(var.jenkins_secrets)
  secret_id     = element(aws_secretsmanager_secret.jenkins.*.id, count.index)
  secret_string = element(values(var.jenkins_secrets), count.index)
}


module "jenkins" {
  source = "../modules/jenkins"

  ami_id               = "ami-066333d9c572b0680" # AMI for an Amazon Linux instance for region: us-east-1
  iam_instance_profile = aws_iam_instance_profile.jenkins.name
  key_pair             = aws_key_pair.jenkins-key.key_name
  name                 = "jenkins"
  device_index         = 0
  network_interface_id = aws_network_interface.jenkins.id
  public_dns           = aws_eip.jenkins.public_dns
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  admin_fullname       = var.admin_fullname
  admin_email          = var.admin_email
  bucket_config_name   = aws_s3_bucket.jenkins_config.id
  remote_repo          = var.remote_repo
  job_name             = var.job_name
  job_id               = random_id.job_id.id

  bucket_logs_name     = "test-abc"
  s3_jenkins_config_id = aws_s3_bucket.jenkins_config.id
}