variable "region" {
  description = "AWS region"
  type        = string
}

variable "namespace" {
  description = "The desired AWS account alias."
  type        = string
}

variable "state_bucket_name" {
  description = "Name for the Terraform State bucket"
  type = string
}

variable "logs_bucket_name" {
  description = "Name for the AWS logs bucket"
  type = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB Table for locking Terraform state."
  default     = "terraform-state-lock"
  type        = string
}

variable "dynamodb_table_tags" {
  description = "Tags of the DynamoDB Table for locking Terraform state."
  default = {
    Name       = "terraform-state-lock"
    ManagedBy  = "Terraform"
  }
  type = map(string)
}

variable "log_retention" {
  description = "Log retention of access logs of state bucket."
  default     = 90
  type        = number
}

variable "log_name" {
  description = "Log name (for backwards compatibility this can be modified to logs)"
  default     = "log"
  type        = string
}

variable "log_bucket_versioning" {
  description = "Bool for toggling versioning for log bucket"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Default tags"
  default = {
    ManagedBy = "Terraform"
  }
}