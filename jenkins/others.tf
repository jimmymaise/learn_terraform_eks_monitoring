# S3 Bucket storing jenkins user data

resource "aws_s3_bucket" "jenkins-config" {
  bucket = var.bucket-config-name
  acl    = "private"
}

resource "aws_key_pair" "jenkins-key" {
  key_name   = "jenkins"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlQk+ars+utu+TNbcXv7ZyTUF9FM5Lv58HvCCpR0oCZm3PTunMVzS04d7S9UBnC2e8UFCyWkqqn7dacve6+EGoZlwjevffZ/Mj0MM8NBQI2CPxKF6grn6zfhL/seQzCpn9Agoo3mN8E5Dz2upi0ii8oabs1xHJAJFC9DhbiSXpjdI925e1Vi/cDt0S8NLagmg1lxrlI/5xcfjfGn1qyqBgBUWOK4aCBR0CbNJkFa9pp8kclES9+8B/tiJfGF4y+w7rJApZFp3CofFtbpj74R5bH+raGHIzQ/ZqjrM0GbqVZfz2g2xjLfRiPkIUWpcJvdUKY051ywsjwb08toTNUsdP duyetmai@ip-172-24-0-206.us-west-2.compute.internal"
}

resource "random_id" "job-id" {
  byte_length = 16
}