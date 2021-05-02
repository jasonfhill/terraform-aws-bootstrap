//data "aws_iam_account_alias" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "supplemental_policy" {

  statement {
    sid    = "enforce-tls-requests-only"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = [
      "arn::s3:::${var.bucket}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  statement {
    sid    = "inventory-and-analytics"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions = ["s3:PutObject"]
    resources = [
      "arn::s3:::${var.bucket}/*"
    ]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn::s3:::${var.bucket}"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket" "private_bucket" {
  bucket        = var.bucket
  acl           = "private"
  tags          = var.tags
  policy        = data.aws_iam_policy_document.supplemental_policy.json
  force_destroy = var.enable_bucket_force_destroy

  versioning {
    enabled = var.enable_versioning
  }

  lifecycle_rule {
    enabled = true

    abort_incomplete_multipart_upload_days = var.abort_incomplete_multipart_upload_days

    dynamic "expiration" {
      for_each = var.expiration
      content {
        date = lookup(expiration.value, "date", null)
        days = lookup(expiration.value, "days", 0)

        expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", false)
      }
    }

    noncurrent_version_expiration {
      days = var.noncurrent_version_expiration
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
        kms_master_key_id = length(var.kms_master_key_id) > 0 ? var.kms_master_key_id : null
      }
    }
  }

}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.private_bucket.id
  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
}

