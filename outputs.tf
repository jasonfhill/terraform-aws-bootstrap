output "state_bucket" {
  description = "The state_bucket name"
  value       = module.terraform_state_bucket.id
}

output "logging_bucket" {
  description = "The logging_bucket name"
  value       = module.terraform_logs_bucket.outputs.aws_logs_bucket
}

output "dynamodb_table" {
  description = "The name of the dynamo db table"
  value       = aws_dynamodb_table.terraform_state_lock.id
}