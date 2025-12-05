# Role que a EC2 vai assumir
resource "aws_iam_role" "ec2_role" {
  name = "role-ec2-app"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Política de trust para a EC2 assumir a role
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Política customizada: DynamoDB + CloudWatch
data "aws_iam_policy_document" "ec2_policy" {
  statement {
    sid     = "DynamoDBAccess"
    effect  = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
    ]
    resources = [aws_dynamodb_table.produtos.arn]
  }

  statement {
    sid     = "CloudWatchLogs"
    effect  = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2_policy" {
  name        = "policy-ec2-dynamodb-cloudwatch"
  description = "Permite EC2 acessar DynamoDB e CloudWatch Logs"

  policy = data.aws_iam_policy_document.ec2_policy.json
}

# Instance profile para associar à EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "instance-profile-ec2-app"
  role = aws_iam_role.ec2_role.name
}

# Anexa a política customizada à role
resource "aws_iam_role_policy_attachment" "ec2_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

# Anexa a política gerenciada do SSM (para Session Manager)
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
