variable "bucket" {
  description = "The name of the bucket."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the bucket."
  default     = {}
  type        = map(string)
}

variable "enable_bucket_force_destroy" {
  type        = bool
  default     = false
  description = "If set to true, Bucket will be emptied and destroyed when terraform destroy is run."
}

variable "enable_versioning" {
  description = "Enables versioning on the bucket."
  type        = bool
  default     = true
}

variable "abort_incomplete_multipart_upload_days" {
  description = "Number of days until aborting incomplete multipart uploads"
  type        = number
  default     = 14
}

variable "expiration" {
  description = "expiration blocks"
  type        = list(any)
  default = [
    {
      expired_object_delete_marker = true
    }
  ]
}

variable "noncurrent_version_expiration" {
  description = "Number of days until non-current version of object expires"
  type        = number
  default     = 365
}

variable "sse_algorithm" {
  description = "The server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
  type        = string
  default     = "AES256"
}

variable "kms_master_key_id" {
  description = "The AWS KMS master key ID used for the SSE-KMS encryption."
  type        = string
  default     = ""
}