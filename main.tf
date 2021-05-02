locals {
  state_bucket_name   = "${var.account_alias}-tf-state-${var.region}"
  logs_bucket_name    = "${var.account_alias}-logs-${var.region}"
}

resource "aws_iam_account_alias" "alias" {
  account_alias = var.account_alias
}

module "terraform_state_bucket" {
  source  = "./modules/state_bucket"

  bucket         = local.state_bucket_name

  tags = {
    ManagedBy = "Terraform"
  }
}

module "terraform_logs_bucket" {
  source = "./modules/logs_bucket"

  s3_bucket_name = local.logs_bucket_name

  tags = {
    ManagedBy = "Terraform"
  }
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