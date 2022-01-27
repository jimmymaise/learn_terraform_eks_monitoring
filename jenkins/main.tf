module "jenkins" {
  source = "../modules/jenkins"

  ami-id               = "ami-066333d9c572b0680" # AMI for an Amazon Linux instance for region: us-east-1
  iam-instance-profile = aws_iam_instance_profile.jenkins.name
  key-pair             = aws_key_pair.jenkins-key.key_name
  name                 = "jenkins"
  device-index         = 0
  network-interface-id = aws_network_interface.jenkins.id
  public-dns           = aws_eip.jenkins.public_dns
  admin-username       = var.admin-username
  admin-password       = var.admin-password
  admin-fullname       = var.admin-fullname
  admin-email          = var.admin-email
  bucket-config-name   = aws_s3_bucket.jenkins-config.id
  remote-repo          = var.remote-repo
  job-name             = var.job-name
  job-id               = random_id.job-id.id

  bucket-logs-name     = "test-abc"
  s3-jenkins-config-id = aws_s3_bucket.jenkins-config.id
}