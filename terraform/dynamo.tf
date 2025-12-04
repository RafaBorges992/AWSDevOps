resource "aws_dynamodb_table" "produtos" {
  name         = "produtos"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name    = "Tabela-produtos"
    Project = var.project_name
  }
}

resource "aws_dynamodb_table_item" "produto1" {
  table_name = aws_dynamodb_table.produtos.name
  hash_key   = "id"

  item = jsonencode({
    id    = { S = "1" }
    nome  = { S = "Camiseta Básica" }
    preco = { N = "39.90" }
  })
}

resource "aws_dynamodb_table_item" "produto2" {
  table_name = aws_dynamodb_table.produtos.name
  hash_key   = "id"

  item = jsonencode({
    id    = { S = "2" }
    nome  = { S = "Tenis Casual" }
    preco = { N = "149.90" }
  })
}

resource "aws_dynamodb_table_item" "produto3" {
  table_name = aws_dynamodb_table.produtos.name
  hash_key   = "id"

  item = jsonencode({
    id    = { S = "3" }
    nome  = { S = "Relogio de Pulso" }
    preco = { N = "89.90" }
  })
}
