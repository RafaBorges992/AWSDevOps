resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "Security group for app instance"
  vpc_id      = aws_vpc.main.id

  # HTTP 80 liberado pro mundo (p/ teste)
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
    Name    = "app-sg"
    Project = var.project_name
  }
}
