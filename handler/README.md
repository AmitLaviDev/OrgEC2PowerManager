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

- [aws_cloudwatch_event_rule.scheduler_start_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) (resource)
- [aws_cloudwatch_event_rule.scheduler_stop_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) (resource)
- [aws_cloudwatch_event_target.start_lambda_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) (resource)
- [aws_cloudwatch_event_target.stop_lambda_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) (resource)
- [aws_cloudwatch_log_group.lambda_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) (resource)
- [aws_iam_role.lambda_exec_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_iam_role_policy.lambda_exec_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) (resource)
- [aws_lambda_function.scheduler_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) (resource)
- [aws_lambda_permission.allow_cloudwatch_to_call_scheduler_start](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) (resource)
- [aws_lambda_permission.allow_cloudwatch_to_call_scheduler_stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_account"></a> [account](#input\_account)

Description: AWS account ID

Type: `string`

### <a name="input_lambda_package_path"></a> [lambda\_package\_path](#input\_lambda\_package\_path)

Description: Path to the Lambda package ZIP file (Can be S3 URL or local path)

Type: `string`

### <a name="input_regions"></a> [regions](#input\_regions)

Description: List of AWS regions where resources should be deployed.

Type: `list(string)`

### <a name="input_target_accounts"></a> [target\_accounts](#input\_target\_accounts)

Description: Map of target account names to account IDs for cross-account role assumptions.

Type: `map(string)`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_instance_schedule_tags"></a> [instance\_schedule\_tags](#input\_instance\_schedule\_tags)

Description: Tags used for the instance scheduler, e.g., NightlySchedule, WeekendSchedule.

Type: `map(string)`

Default:

```json
{
  "NightlySchedule": "nightly-shutdown",
  "WeekendSchedule": "weekend-shutdown"
}
```

### <a name="input_periods"></a> [periods](#input\_periods)

Description: Period definitions for different schedules.

Type:

```hcl
map(object({
    begintime = string
    endtime   = string
    weekdays  = list(string)
  }))
```

Default:

```json
{
  "nightly": {
    "begintime": "18:00",
    "endtime": "06:00",
    "weekdays": [
      "sun",
      "mon",
      "tue",
      "wed",
      "thu"
    ]
  },
  "weekend": {
    "begintime": "00:00",
    "endtime": "24:00",
    "weekdays": [
      "fri",
      "sat"
    ]
  }
}
```

### <a name="input_schedules"></a> [schedules](#input\_schedules)

Description: Schedule definitions for instance management.

Type:

```hcl
map(object({
    timezone           = string
    periods            = list(string)
    description        = string
    enforced           = bool
    stop_new_instances = bool
  }))
```

Default:

```json
{
  "nightly-shutdown": {
    "description": "Shuts down every night",
    "enforced": true,
    "periods": [
      "nightly"
    ],
    "stop_new_instances": true,
    "timezone": "Asia/Jerusalem"
  },
  "weekend-shutdown": {
    "description": "Shuts down during weekends",
    "enforced": true,
    "periods": [
      "weekend"
    ],
    "stop_new_instances": true,
    "timezone": "Asia/Jerusalem"
  }
}
```

### <a name="input_start_time_local"></a> [start\_time\_local](#input\_start\_time\_local)

Description: Schedule start time in local time (24-hour format).

Type: `number`

Default: `6`

### <a name="input_stop_time_local"></a> [stop\_time\_local](#input\_stop\_time\_local)

Description: Schedule stop time in local time (24-hour format).

Type: `number`

Default: `18`

### <a name="input_utc_time_diff"></a> [utc\_time\_diff](#input\_utc\_time\_diff)

Description: Time difference between UTC and local time.

Type: `number`

Default: `0`

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
| [aws_cloudwatch_event_rule.scheduler_start_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.scheduler_stop_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.start_lambda_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.stop_lambda_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.lambda_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda_exec_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_exec_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.scheduler_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch_to_call_scheduler_start](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.allow_cloudwatch_to_call_scheduler_stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | AWS account ID | `string` | n/a | yes |
| <a name="input_instance_schedule_tags"></a> [instance\_schedule\_tags](#input\_instance\_schedule\_tags) | Tags used for the instance scheduler, e.g., NightlySchedule, WeekendSchedule. | `map(string)` | <pre>{<br/>  "NightlySchedule": "nightly-shutdown",<br/>  "WeekendSchedule": "weekend-shutdown"<br/>}</pre> | no |
| <a name="input_lambda_package_path"></a> [lambda\_package\_path](#input\_lambda\_package\_path) | Path to the Lambda package ZIP file (Can be S3 URL or local path) | `string` | n/a | yes |
| <a name="input_periods"></a> [periods](#input\_periods) | Period definitions for different schedules. | <pre>map(object({<br/>    begintime = string<br/>    endtime   = string<br/>    weekdays  = list(string)<br/>  }))</pre> | <pre>{<br/>  "nightly": {<br/>    "begintime": "18:00",<br/>    "endtime": "06:00",<br/>    "weekdays": [<br/>      "sun",<br/>      "mon",<br/>      "tue",<br/>      "wed",<br/>      "thu"<br/>    ]<br/>  },<br/>  "weekend": {<br/>    "begintime": "00:00",<br/>    "endtime": "24:00",<br/>    "weekdays": [<br/>      "fri",<br/>      "sat"<br/>    ]<br/>  }<br/>}</pre> | no |
| <a name="input_regions"></a> [regions](#input\_regions) | List of AWS regions where resources should be deployed. | `list(string)` | n/a | yes |
| <a name="input_schedules"></a> [schedules](#input\_schedules) | Schedule definitions for instance management. | <pre>map(object({<br/>    timezone           = string<br/>    periods            = list(string)<br/>    description        = string<br/>    enforced           = bool<br/>    stop_new_instances = bool<br/>  }))</pre> | <pre>{<br/>  "nightly-shutdown": {<br/>    "description": "Shuts down every night",<br/>    "enforced": true,<br/>    "periods": [<br/>      "nightly"<br/>    ],<br/>    "stop_new_instances": true,<br/>    "timezone": "Asia/Jerusalem"<br/>  },<br/>  "weekend-shutdown": {<br/>    "description": "Shuts down during weekends",<br/>    "enforced": true,<br/>    "periods": [<br/>      "weekend"<br/>    ],<br/>    "stop_new_instances": true,<br/>    "timezone": "Asia/Jerusalem"<br/>  }<br/>}</pre> | no |
| <a name="input_start_time_local"></a> [start\_time\_local](#input\_start\_time\_local) | Schedule start time in local time (24-hour format). | `number` | `6` | no |
| <a name="input_stop_time_local"></a> [stop\_time\_local](#input\_stop\_time\_local) | Schedule stop time in local time (24-hour format). | `number` | `18` | no |
| <a name="input_target_accounts"></a> [target\_accounts](#input\_target\_accounts) | Map of target account names to account IDs for cross-account role assumptions. | `map(string)` | n/a | yes |
| <a name="input_utc_time_diff"></a> [utc\_time\_diff](#input\_utc\_time\_diff) | Time difference between UTC and local time. | `number` | `0` | no |

## Outputs

No outputs.
