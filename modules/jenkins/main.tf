resource "aws_s3_bucket_object" "jenkins_config" {
  bucket   = var.s3-jenkins_config-id
  for_each = fileset("${path.module}/data/config_scripts/", "*")
  key      = each.value
  source   = "${path.module}/data/config_scripts/${each.value}"
  etag     = filemd5("${path.module}/data/config_scripts/${each.value}")
}

resource "aws_instance" "default" {
  ami                  = var.ami-id
  iam_instance_profile = var.iam-instance-profile
  instance_type        = var.instance-type
  key_name             = var.key-pair
  network_interface {
    device_index         = var.device-index
    network_interface_id = var.network_interface_id
  }

  user_data = templatefile(
  "${path.module}/data/user_data.sh",
  {
    bucket_logs_name   = var.bucket-logs-name,
    public_dns         = var.public-dns,
    admin_username     = var.admin_username,
    admin_password     = var.admin_password,
    admin_fullname     = var.admin_fullname,
    admin_email        = var.admin_email,
    remote_repo        = var.remote_repo,
    job_name           = var.job_name,
    job_id             = var.job_id,
    bucket_config_name = var.bucket_config_name
  }
  )

  tags = {
    Name = var.name
  }
}