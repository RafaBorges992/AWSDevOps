output "ec2_public_ip" {
  description = "IP público da instância EC2"
  value       = aws_instance.app.public_ip
}

output "ec2_public_dns" {
  description = "DNS público da instância EC2"
  value       = aws_instance.app.public_dns
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.produtos.name
}
