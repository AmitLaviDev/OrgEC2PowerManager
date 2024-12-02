import boto3
import os
import json
from datetime import datetime
import pytz
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Load environment variables
SCHEDULES = json.loads(os.getenv("SCHEDULES", "{}"))
if not SCHEDULES:
    logger.warning("SCHEDULES environment variable is empty or not provided.")
PERIODS = json.loads(os.getenv("PERIODS", "{}"))
if not PERIODS:
    logger.warning("PERIODS environment variable is empty or not provided.")
TARGET_ACCOUNTS = json.loads(os.getenv("TARGET_ACCOUNTS", "{}"))
if not TARGET_ACCOUNTS:
    logger.warning("TARGET_ACCOUNTS environment variable is empty or not provided.")
AWS_REGION = os.getenv("AWS_REGION")
if not AWS_REGION:
    logger.warning("AWS_REGION environment variable is not provided.")
ROLE_NAME = os.getenv("ROLE_NAME", "TargetInstanceSchedulerRole")
if not ROLE_NAME:
    logger.warning(
        "ROLE_NAME environment variable is not provided; using default: TargetInstanceSchedulerRole."
    )


def lambda_handler(event, context):
    logger.info(f"Received event: {event}")
    action = event.get("action", "check")
    current_time = datetime.now(pytz.timezone("UTC"))
    logger.info(f"Current UTC time: {current_time}")

    for account_name, account_id in TARGET_ACCOUNTS.items():
        logger.info(f"Processing account: {account_name} ({account_id})")
        try:
            sts_credentials = assume_role(account_id)
            ec2 = get_ec2_client(sts_credentials)
            process_instances(ec2, account_id, action, current_time)
        except Exception as e:
            logger.error(f"Error processing account {account_name}: {str(e)}")
        logger.info(f"Finished processing account: {account_name} ({account_id})")


def process_instances(ec2, account_id, action, current_time):
    try:
        all_instances = ec2.describe_instances()
        log_all_instances(all_instances, account_id)

        for schedule_name, schedule in SCHEDULES.items():
            action_to_take = should_execute_schedule(schedule, current_time, action)
            if action_to_take:
                logger.info(f"Executing {action_to_take} for schedule {schedule_name}")
                execute_schedule(ec2, schedule_name, action_to_take)
            else:
                logger.info(f"No action needed for schedule {schedule_name}")
    except Exception as e:
        logger.error(f"Error describing instances in account {account_id}: {str(e)}")


def log_all_instances(all_instances, account_id):
    for reservation in all_instances["Reservations"]:
        for instance in reservation["Instances"]:
            instance_id = instance["InstanceId"]
            instance_state = instance["State"]["Name"]
            instance_tags = instance.get("Tags", [])
            logger.info(
                f"Instance ID: {instance_id}, State: {instance_state}, Tags: {instance_tags}"
            )


def should_execute_schedule(schedule, current_time, action):
    timezone = pytz.timezone(schedule["timezone"])
    local_time = current_time.astimezone(timezone)
    current_day = local_time.strftime("%a").lower()
    current_hour = local_time.hour
    current_minute = local_time.minute

    logger.info(f"Checking schedule: local time {local_time}, day {current_day}")

    for period_name in schedule["periods"]:
        period = PERIODS[period_name]
        if current_day in period["weekdays"]:
            start_hour, start_minute = map(int, period["begintime"].split(":"))
            end_hour, end_minute = map(int, period["endtime"].split(":"))

            logger.info(
                f"Period {period_name}: start {start_hour}:{start_minute}, end {end_hour}:{end_minute}"
            )

            current_minutes = current_hour * 60 + current_minute
            start_minutes = start_hour * 60 + start_minute
            end_minutes = end_hour * 60 + end_minute

            if end_minutes < start_minutes:
                if current_minutes >= start_minutes or current_minutes < end_minutes:
                    return "stop"
                else:
                    return "start"
            else:
                if start_minutes <= current_minutes < end_minutes:
                    return "stop"
                else:
                    return "start"

    return None


def execute_schedule(ec2, schedule_name, action):
    if action == "stop":
        stop_instances(ec2, schedule_name)
    elif action == "start":
        start_instances(ec2, schedule_name)
    elif action == "check":
        stop_instances(ec2, schedule_name)
        start_instances(ec2, schedule_name)


def assume_role(account_id):
    logger.info(f"Assuming role for account: {account_id}")
    sts_client = boto3.client("sts")
    role_arn = f"arn:aws:iam::{account_id}:role/{ROLE_NAME}"
    try:
        response = sts_client.assume_role(
            RoleArn=role_arn, RoleSessionName="LambdaCrossAccountSession"
        )
        logger.info(f"Successfully assumed role for account: {account_id}")
        return response["Credentials"]
    except Exception as e:
        logger.error(f"Failed to assume role for account {account_id}: {str(e)}")
        raise


def get_ec2_client(credentials, region=AWS_REGION):
    return boto3.client(
        "ec2",
        region_name=region,
        aws_access_key_id=credentials["AccessKeyId"],
        aws_secret_access_key=credentials["SecretAccessKey"],
        aws_session_token=credentials["SessionToken"],
    )


def stop_instances(ec2, schedule_name):
    logger.info(f"Stopping instances for schedule: {schedule_name}")
    try:
        instance_ids = get_instances_by_schedule(ec2, schedule_name, "running")
        if instance_ids:
            ec2.stop_instances(InstanceIds=instance_ids)
            logger.info(f"Stopped instances: {instance_ids}")
        else:
            logger.info(
                f"No running instances found to stop for schedule: {schedule_name}"
            )
    except Exception as e:
        logger.error(f"Error stopping instances for schedule {schedule_name}: {str(e)}")


def start_instances(ec2, schedule_name):
    logger.info(f"Starting instances for schedule: {schedule_name}")
    try:
        instance_ids = get_instances_by_schedule(ec2, schedule_name, "stopped")
        if instance_ids:
            ec2.start_instances(InstanceIds=instance_ids)
            logger.info(f"Started instances: {instance_ids}")
        else:
            logger.info(
                f"No stopped instances found to start for schedule: {schedule_name}"
            )
    except Exception as e:
        logger.error(f"Error starting instances for schedule {schedule_name}: {str(e)}")


def get_instances_by_schedule(ec2, schedule_name, state):
    tags = ["NightlySchedule", "WeekendSchedule"]
    instance_ids = []
    for tag in tags:
        response = ec2.describe_instances(
            Filters=[{"Name": f"tag:{tag}", "Values": [schedule_name]}]
        )
        for reservation in response["Reservations"]:
            for instance in reservation["Instances"]:
                if instance["State"]["Name"] == state:
                    instance_ids.append(instance["InstanceId"])
    return instance_ids
