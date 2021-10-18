output "account_id" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.this.account_id
}

output "user_id" {
  description = "AWS user ID"
  value       = data.aws_caller_identity.this.user_id
}
output "region" {
  description = "AWS region"
  value       = "${var.region}:${var.az}"
}
output "private_ip" {
  description = "Private IP"
  value       = aws_instance.ubuntu.private_ip
}
output "subnet_id" {
  description = "Subnet ID"
  value       = aws_instance.ubuntu.subnet_id
}