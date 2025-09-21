#!/bin/bash
set -ex
sudo yum update -y
sudo yum install -y nginx

# Create API page
mkdir -p /usr/share/nginx/html/api
echo "<h1>API Service - $(hostname -f)</h1>" > /usr/share/nginx/html/api/index.html

# Create APP page
mkdir -p /usr/share/nginx/html/app
echo "<h1>APP Service - $(hostname -f)</h1>" > /usr/share/nginx/html/app/index.html

sudo systemctl enable nginx
sudo systemctl start nginx


# Install CloudWatch Agent
sudo yum install -y amazon-cloudwatch-agent

# CloudWatch Agent configuration
cat <<EOL | sudo tee /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "metrics": {
    "append_dimensions": {
      "AutoScalingGroupName": "\${aws:AutoScalingGroupName}",
      "InstanceId": "\${aws:InstanceId}"
    },
    "metrics_collected": {
      "cpu": {
        "measurement": ["usage_idle","usage_user","usage_system"],
        "metrics_collection_interval": 60,
        "totalcpu": true
      },
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": ["used_percent"],
        "metrics_collection_interval": 60,
        "resources": ["/"]
      }
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/nginx/access.log",
            "log_group_name": "${local.env}-nginx-access",
            "log_stream_name": "{instance_id}",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/nginx/error.log",
            "log_group_name": "${local.env}-nginx-error",
            "log_stream_name": "{instance_id}",
            "timezone": "UTC"
          }
        ]
      }
    }
  }
}
EOL

# Start CloudWatch Agent# Start CloudWatch Agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
