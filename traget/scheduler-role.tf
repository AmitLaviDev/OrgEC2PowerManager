resource "aws_iam_role" "target_instance_scheduler_role" {
  name = "TargetInstanceSchedulerRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.source_account_num}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "target_instance_scheduler_policy" {
  name = "TargetInstanceSchedulerPolicy"
  role = aws_iam_role.target_instance_scheduler_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:StopInstances",
          "ec2:StartInstances"
        ]
        Resource = "*"
      },
      {
        Sid : "GrantAccess",
        Effect : "Allow",
        Action : "kms:CreateGrant",
        Resource : "arn:aws:kms:${var.region}:${var.source_account_num}:key/${var.kms_key_id}"
      }
    ]
  })
}
