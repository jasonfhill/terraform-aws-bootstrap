locals {
  tags                        = merge(var.tags,{

  })
}
resource "aws_iam_account_alias" "alias" {
  account_alias = var.namespace
}

resource "aws_kms_key" "this" {
  description             = "The key used to encrypt the remote state bucket"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = var.tags
}

module "terraform_state_bucket" {
  source  = "./modules/state_bucket"

  bucket         = var.state_bucket_name

  tags = var.tags
}

module "terraform_logs_bucket" {
  source = "./modules/logs_bucket"

  s3_bucket_name = var.logs_bucket_name

  tags = var.tags
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = var.dynamodb_table_name
  hash_key       = "LockID"
  read_capacity  = 2
  write_capacity = 2

  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.dynamodb_table_tags
}