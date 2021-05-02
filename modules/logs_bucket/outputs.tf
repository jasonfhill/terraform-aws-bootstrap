output "outputs" {
  description = "Log paths"
  value = {
    aws_logs_bucket = aws_s3_bucket.aws_logs.id
    cloudwatch_logs = var.cloudwatch_logs_prefix
    alb_logs        = var.alb_logs_prefixes
  }
}
output "aws_logs_bucket" {
  description = "ID of the S3 bucket containing AWS logs."
  value       = aws_s3_bucket.aws_logs.id
}

output "configs_logs_path" {
  description = "S3 path for Config logs."
  value       = var.config_logs_prefix
}

output "elb_logs_path" {
  description = "S3 path for ELB logs."
  value       = var.elb_logs_prefix
}

output "alb_logs_prefixes" {
  description = "S3 path for ALB logs."
  value       = var.alb_logs_prefixes
}

output "cloudwatch_logs_prefix" {
  description = "S3 path for Cloudwatch logs."
  value       = var.cloudwatch_logs_prefix
}