# Account specific variables
account = "730335184263"
regions  = [
  "il-central-1"
]

accounts_arns = [
  "arn:aws:iam::381492020195:role/TargetInstanceSchedulerRole",
  "arn:aws:iam::058264438857:role/TargetInstanceSchedulerRole",
  "arn:aws:iam::637423312969:role/TargetInstanceSchedulerRole",
  "arn:aws:iam::008971673223:role/TargetInstanceSchedulerRole",
]

accounts_nums = [
  "381492020195",
  "058264438857",
  "637423312969",
  "008971673223",
]

target_accounts = {
  "M-Bechirot-Main-Prod"      = "381492020195"
  "M-Bechirot-Shared-Network" = "058264438857"
  "M-Bechirot-Main-Test"      = "637423312969"
  "M-Bechirot-Security-Prod"  = "008971673223"
}

schedules = {
  "nightly-shutdown" = {
    timezone = "Asia/Jerusalem"
    periods  = ["nightly"]
  }
  "weekend-shutdown" = {
    timezone = "Asia/Jerusalem"
    periods  = ["weekend"]
  }
}

# Time management
start_time_local = 6
stop_time_local  = 18
utc_time_diff    = 2

# Times in your local timezone, fix utc_time_diff to match your timezone
periods = {
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

lambda_package_path = "../package/power_manager_package.zip"

