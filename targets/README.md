<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_iam_role.target_instance_scheduler_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_iam_role_policy.target_instance_scheduler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id)

Description: The ID of the KMS key to be used for grant access.

Type: `string`

### <a name="input_region"></a> [region](#input\_region)

Description: AWS region where resources are deployed.

Type: `string`

### <a name="input_source_account_num"></a> [source\_account\_num](#input\_source\_account\_num)

Description: AWS account number of the source account that will assume this role.

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.target_instance_scheduler_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.target_instance_scheduler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ID of the KMS key to be used for grant access. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources are deployed. | `string` | n/a | yes |
| <a name="input_source_account_num"></a> [source\_account\_num](#input\_source\_account\_num) | AWS account number of the source account that will assume this role. | `string` | n/a | yes |

## Outputs

No outputs.
