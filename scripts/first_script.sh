#!/bin/bash

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found. Please install it and configure your credentials."
    exit 1
fi

# Prompt for instance ID
read -p "Enter the AWS EC2 instance ID: " INSTANCE_ID

# Get instance details
INSTANCE_DETAILS=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID")

# Check if the instance details were retrieved successfully
if [ $? -ne 0 ]; then
    echo "Failed to retrieve instance details. Please check the instance ID and your AWS CLI configuration."
    exit 1
fi

# Extract and display relevant details
INSTANCE_TYPE=$(echo "$INSTANCE_DETAILS" | jq -r '.Reservations[0].Instances[0].InstanceType')
INSTANCE_STATE=$(echo "$INSTANCE_DETAILS" | jq -r '.Reservations[0].Instances[0].State.Name')
PUBLIC_IP=$(echo "$INSTANCE_DETAILS" | jq -r '.Reservations[0].Instances[0].PublicIpAddress')
AVAILABILITY_ZONE=$(echo "$INSTANCE_DETAILS" | jq -r '.Reservations[0].Instances[0].Placement.AvailabilityZone')

echo "Instance ID: $INSTANCE_ID"
echo "Instance Type: $INSTANCE_TYPE"
echo "Instance State: $INSTANCE_STATE"
echo "Public IP Address: $PUBLIC_IP"
echo "Availability Zone: $AVAILABILITY_ZONE"
