resource "aws_dynamodb_table" "table" {
  name         = var.table_name
  hash_key     = var.hash_key
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = var.attribute_name
    type = var.attribute_type
  }

  tags = {
    Name        = var.table_name
    Environment = var.environment
  }
}
