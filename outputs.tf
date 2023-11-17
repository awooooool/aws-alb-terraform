output "Public-IP" {
  description = "Public IP address of EC2 Instance"
  value       = aws_instance.FastAPI[*].public_ip
}
