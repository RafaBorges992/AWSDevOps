# AMI Amazon Linux 2
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Script de user_data: sobe um Flask com /health e /products
locals {
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3 python3-pip

              pip3 install flask

              cat > /opt/app.py << 'PYEOF'
              from flask import Flask, jsonify

              app = Flask(__name__)

              @app.route("/health")
              def health():
                  return "OK", 200

              @app.route("/products")
              def products():
                  return jsonify([
                      {"id": "1", "nome": "Camiseta Básica", "preco": 39.90},
                      {"id": "2", "nome": "Tenis Casual", "preco": 149.90},
                      {"id": "3", "nome": "Relogio de Pulso", "preco": 89.90},
                  ])

              # aqui você poderia ter /auth, /orders etc.

              if __name__ == "__main__":
                  app.run(host="0.0.0.0", port=80)
              PYEOF

              nohup python3 /opt/app.py > /var/log/app.log 2>&1 &
              EOF
}

resource "aws_instance" "app" {
  ami                         = data.aws_ami.amazon_linux2.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = true
  user_data                   = local.user_data

  tags = {
    Name    = "EC2-microservices-v2"  # força recriação da instância
    Project = var.project_name
  }
}
