# EC2 Power Manager for AWS Organizations

A Terraform module that enables automated starting and stopping of EC2 instances across multiple AWS accounts in an organization.

## Features

- **Multi-Account Support**: Manage instances across multiple AWS accounts in your organization
- **Flexible Scheduling**: Configure when to start or stop instances using CloudWatch Event rules
- **Tag-Based Filtering**: Target specific instances based on tags
- **Exclusion Support**: Exclude critical instances from power management
- **Notifications**: Optional SNS notifications for power management events
- **Cost Optimization**: Reduce cloud costs by automatically stopping non-production instances during off-hours

## Architecture

This module deploys:

1. A Lambda function in the management account
2. IAM roles in member accounts with permissions to control EC2 instances
3. CloudWatch Event rules for scheduling

## Prerequisites

Before using this module, ensure you have:

1. AWS Organizations set up with the desired account structure
2. Permissions to create IAM roles across member accounts
3. Permissions to deploy Lambda functions in the management account

## Usage

### Basic Example

```terraform
module "ec2_power_manager" {
  source = "github.com/amitlavidev/OrgEC2PowerManager"
  
  aws_region  = "us-east-1"
  name_prefix = "nonprod-power-mgr"
  action      = "stop"
