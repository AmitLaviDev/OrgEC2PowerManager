locals {
  # Calculate the corresponding UTC times
  start_time_utc = var.start_time_local - var.utc_time_diff
  stop_time_utc  = var.stop_time_local - var.utc_time_diff
}
