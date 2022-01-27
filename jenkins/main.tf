module "jenkins" {
  source = "../modules/jenkins"

  ami-id               = "ami-066333d9c572b0680" # AMI for an Amazon Linux instance for region: us-east-1
  iam-instance-profile = aws_iam_instance_profile.jenkins.name
  key-pair             = aws_key_pair.jenkins-key.key_name
  name                 = "jenkins"
  device-index         = 0
  network_interface_id = aws_network_interface.jenkins.id
  public-dns           = aws_eip.jenkins.public_dns
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  admin_fullname       = var.admin_fullname
  admin_email          = var.admin_email
  bucket_config_name   = aws_s3_bucket.jenkins_config.id
  remote_repo          = var.remote_repo
  job_name             = var.job_name
  job_id               = random_id.job_id.id

  bucket-logs-name     = "test-abc"
  s3-jenkins_config-id = aws_s3_bucket.jenkins_config.id
}