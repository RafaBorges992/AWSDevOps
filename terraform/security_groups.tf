# Security Group da aplicação (porta 80 aberta para HTTP)
resource "aws_security_group" "app" {
  # Em vez de name fixo, usamos um prefixo.
  # A AWS vai gerar algo como "app-sg-abc123", evitando conflito de nomes.
  name_prefix = "app-sg-"

  description = "Security group for app instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "app-sg"          # Tag de nome (não dá erro de duplicado)
    Project = var.project_name
  }
}
