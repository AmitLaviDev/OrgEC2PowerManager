# Account specific variables
variable "account" {
  description = "AWS account ID"
  type        = string
}

variable "regions" {
  type        = list(string)
  description = "List of AWS regions where resources should be deployed."
}

variable "accounts_arns" {
  type        = list(string)
  description = "List of target ARNs of cross-account roles for instance scheduling"
}

variable "accounts_nums" {
  type        = list(string)
  description = "List of target AWS account numbers for cross-account operations"
}

# Define the variables to allow customization
variable "instance_schedule_tags" {
  type        = map(string)
  description = "Tags used for the instance scheduler, e.g., NightlySchedule, WeekendSchedule."
  default = {
    NightlySchedule = "nightly-shutdown"
    WeekendSchedule = "weekend-shutdown"
  }
}

variable "target_accounts" {
  type        = map(string)
  description = "Map of target account names to account IDs for cross-account role assumptions."
}

variable "schedules" {
  type = map(object({
    timezone           = string
    periods            = list(string)
    description        = string
    enforced           = bool
    stop_new_instances = bool
  }))
  description = "Schedule definitions for instance management."
  default = {
    "nightly-shutdown" = {
      timezone           = "Asia/Jerusalem"
      periods            = ["nightly"]
      description        = "Shuts down every night"
      enforced           = true
      stop_new_instances = true
    }
    "weekend-shutdown" = {
      timezone           = "Asia/Jerusalem"
      periods            = ["weekend"]
      description        = "Shuts down during weekends"
      enforced           = true
      stop_new_instances = true
    }
  }
}

variable "periods" {
  type = map(object({
    begintime = string
    endtime   = string
    weekdays  = list(string)
  }))
  description = "Period definitions for different schedules."
  default = {
    "nightly" = {
      begintime = "18:00"
      endtime   = "06:00"
      weekdays  = ["sun", "mon", "tue", "wed", "thu"]
    }
    "weekend" = {
      begintime = "00:00"
      endtime   = "24:00"
      weekdays  = ["fri", "sat"]
    }
  }
}

variable "utc_time_diff" {
  type        = number
  description = "Time difference between UTC and Israel time."
}

variable "start_time_local" {
  type        = number
  description = "Start time in Israel local time (24-hour format)."
}

variable "stop_time_local" {
  type        = number
  description = "Stop time in Israel local time (24-hour format)."
}

variable "lambda_package_path" {
  description = "Path to the Lambda package ZIP file (Can be S3 URL or local path)"
  type        = string
}
