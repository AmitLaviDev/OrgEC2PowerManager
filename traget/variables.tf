variable "source_account_num" {
  type        = string
  description = "AWS account number of the source account that will assume this role."
}

variable "region" {
  type        = string
  description = "AWS region where resources are deployed."
}

variable "kms_key_id" {
  type        = string
  description = "The ID of the KMS key to be used for grant access."
}
