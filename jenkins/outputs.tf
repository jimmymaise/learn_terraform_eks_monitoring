output "ec2_ip" {
  description = "EKS cluster ID."
  value       = aws_eip.jenkins.public_ip
}